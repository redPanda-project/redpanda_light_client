// @dart=2.9
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

class Channel {
  DBChannel _dbChannel;
  String _name;
  NodeId _nodeId;
  Map<String, dynamic> _channelData;

  Channel(this._dbChannel) {
    _name = _dbChannel.name;
  }

  Channel.newWithName(String name) {
    _name = name;
  }

  setChannelData(Map<String, dynamic> value) {
    _channelData = value;
  }

  static insertSharedChannel(String data, String newName) {
    var base58decode = Utils.base58decode(data);
    var byteBuffer = ByteBuffer.fromList(base58decode);

    int nodeIdLen = byteBuffer.length - 32 - 4;

    var sharedSecret = byteBuffer.readBytes(32);
    var privateSigningKey = byteBuffer.readBytes(nodeIdLen);
    var checksum = byteBuffer.readBytes(4);

    var hashbuffer = ByteBuffer(32 + nodeIdLen);
    hashbuffer.writeList(sharedSecret);
    hashbuffer.writeList(privateSigningKey);
    var sha256 = Utils.sha256(hashbuffer.array());
    var computedCheckSum = sha256.sublist(0, 4);

    if (!Utils.listsAreEqual(computedCheckSum, checksum)) {
      throw new Exception("This is not a valid shared channel! " + data);
    }

    ConnectionService.appDatabase.createChannelFromData(newName, sharedSecret, privateSigningKey);
    print("sucessfully added new channel...");
  }

  int getId() {
    return _dbChannel.id;
  }

  NodeId getNodeId() {
    _nodeId ??= NodeId.importWithPrivate(_dbChannel.nodeId);

    return _nodeId;
  }

  setNodeId(NodeId value) {
    _nodeId = value;
  }

  /**
   * Uses the sharedSecrete from the underlying DBChannel to encrypt the given data.
   */
  Uint8List encryptAES(Uint8List bytes, Uint8List iv) {
    var cbcBlockCipher = CBCBlockCipher(AESFastEngine());

    ParametersWithIV parametersWithIV = ParametersWithIV(KeyParameter(_dbChannel.sharedSecret), iv);

    cbcBlockCipher.init(true, parametersWithIV);

    int bytesWithFullBlock = 16 - bytes.length % 16;

    int fullLen = bytes.length + bytesWithFullBlock;

    var paddedBuffer = ByteBuffer(bytes.length + bytesWithFullBlock);
    paddedBuffer.writeList(bytes);

    var padding = new Padding("PKCS7");
    padding.init();

    padding.addPadding(paddedBuffer.array(), bytes.length);

    var encBytes = new Uint8List(fullLen);
    int currentStart = 0;

    int len = 0;
    while (currentStart + 16 <= fullLen) {
      len += cbcBlockCipher.processBlock(paddedBuffer.array(), currentStart, encBytes, currentStart);
      currentStart += 16;
    }

    return encBytes;
  }

  /**
   * Uses the sharedSecrete from the underlying DBChannel to decrypt the given data.
   */
  Uint8List decryptAES(Uint8List bytes, Uint8List iv) {
    ParametersWithIV parametersWithIV = ParametersWithIV(KeyParameter(_dbChannel.sharedSecret), iv);

    var dec = CBCBlockCipher(AESFastEngine());
    dec.init(false, parametersWithIV);

    var decryptedBytes = new Uint8List(bytes.length);
    int currentStart = 0;

    while (currentStart + 16 <= bytes.length) {
      dec.processBlock(bytes, currentStart, decryptedBytes, currentStart);
      currentStart += 16;
    }

    var padding2 = new Padding("PKCS7");
    padding2.init();

    int padCount = padding2.padCount(decryptedBytes);
    //remove padding
    decryptedBytes = decryptedBytes.sublist(0, decryptedBytes.lengthInBytes - padCount);

    return decryptedBytes;
  }

  String get name => _name;

  DBChannel get dbChannel => _dbChannel;

  set dbChannel(DBChannel value) {
    _dbChannel = value;
  }

  Map<String, dynamic> getChannelData() {
    if (_channelData == null) {
      if (_dbChannel.channelData != null) {
//        _channelData = ChannelData.fromJson(jsonDecode(_dbChannel.channelData));
        _channelData = jsonDecode(_dbChannel.channelData);
      } else {
        _channelData = {};
      }
    }
    return _channelData;
  }

  Future<void> saveChannelData(AppDatabase appDatabase) async {
    await appDatabase.updateChannelData(_dbChannel.id, jsonEncode(_channelData));
  }

  void setUserData(int myUserId, Map<String, dynamic> myUserdata) {
    if (_channelData == null) {
      _channelData = {};
      _channelData['userdata'] = {};
    }

    _channelData["userdata"][myUserId.toString()] = myUserdata;
  }

  String shareString() {
    var hashbuffer = ByteBuffer(32 + _dbChannel.nodeId.length);
    hashbuffer.writeList(_dbChannel.sharedSecret);
    hashbuffer.writeList(_dbChannel.nodeId);
    var sha256 = Utils.sha256(hashbuffer.array());

    var byteBuffer = ByteBuffer(32 + _dbChannel.nodeId.length + 4);
    byteBuffer.writeList(_dbChannel.sharedSecret);
    byteBuffer.writeList(_dbChannel.nodeId);
    byteBuffer.writeList(sha256.sublist(0, 4));

    return Utils.base58encode(byteBuffer.array());
  }
}
