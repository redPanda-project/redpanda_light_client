import 'dart:convert';

import 'package:moor/moor.dart';
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

//    print("full length: " + (bytes.length + bytesWithFullBlock).toString());

    var paddedBuffer = ByteBuffer(bytes.length + bytesWithFullBlock);
    paddedBuffer.writeList(bytes);

    var padding = new Padding("PKCS7");
    padding.init();

//    print("offset: " + bytes.length.toString());
    padding.addPadding(paddedBuffer.array(), bytes.length);

//    print("dec byte with pad: " + Utils.hexEncode(paddedBuffer.array()));

    var encBytes = new Uint8List(fullLen);
    int currentStart = 0;

    int len = 0;
    while (currentStart + 16 <= fullLen) {
      len += cbcBlockCipher.processBlock(paddedBuffer.array(), currentStart, encBytes, currentStart);
      currentStart += 16;
    }

//    print("len: " + len.toString());

//    print("enc byte: " + Utils.hexEncode(encBytes));

    return encBytes;
  }

  /**
   * Uses the sharedSecrete from the underlying DBChannel to decrypt the given data.
   */
  Uint8List decryptAES(Uint8List bytes, Uint8List iv) {
    var cbcBlockCipher = CBCBlockCipher(AESFastEngine());
    ParametersWithIV parametersWithIV = ParametersWithIV(KeyParameter(_dbChannel.sharedSecret), iv);

    var dec = CBCBlockCipher(AESFastEngine());
    dec.init(false, parametersWithIV);

    var decryptedBytes = new Uint8List(bytes.length);
    int currentStart = 0;
//    print("to dec bytes: " + bytes.length.toString());

    while (currentStart + 16 <= bytes.length) {
      dec.processBlock(bytes, currentStart, decryptedBytes, currentStart);
      currentStart += 16;
    }

    var padding2 = new Padding("PKCS7");
    padding2.init();

//    print("dec byte: " + Utils.hexEncode(decryptedBytes));
    int padCount = padding2.padCount(decryptedBytes);

//    print('pad cnt: ' + padCount.toString());

    //remove padding
    decryptedBytes = decryptedBytes.sublist(0, decryptedBytes.lengthInBytes - padCount);

//    print(Utils.hexEncode(decryptedBytes));
//    print(decryptedBytes.length);

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

  void setUserData(String myUserId, Map<String, dynamic> myUserdata) {
    _channelData["userdata"][myUserId] = myUserdata;
  }
}
