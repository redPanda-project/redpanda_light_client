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

  Channel(this._dbChannel) {
    _name = _dbChannel.name;
  }

  Channel.newWithName(String name) {
    _name = name;
  }

  NodeId getNodeId() {
    if (_nodeId == null)  {
      _nodeId = NodeId.importWithPrivate(_dbChannel.nodeId);
    }

    return _nodeId;
  }

  /**
   * Uses the sharedSecrete from the underlying DBChannel to encrypt the given data.
   */
  Uint8List encryptAES(Uint8List bytes, Uint8List iv) {
    var cbcBlockCipher = CBCBlockCipher(AESFastEngine());

    ParametersWithIV parametersWithIV = ParametersWithIV(KeyParameter(_dbChannel.sharedSecret), iv);

    cbcBlockCipher.init(true, parametersWithIV);

    int bytesWithFullBlock = 16 - bytes.length % 16;

    print(bytes.length + bytesWithFullBlock);

    var paddedBuffer = ByteBuffer(bytes.length + bytesWithFullBlock);
    paddedBuffer.writeList(bytes);

    var padding = new Padding("PKCS7");
    padding.init();

    padding.addPadding(paddedBuffer.array(), bytes.length);

    Uint8List encBytes = cbcBlockCipher.process(paddedBuffer.array());
    print("enc byte: " + Utils.hexEncode(encBytes));

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

    Uint8List decBytes = dec.process(bytes);

    var padding2 = new Padding("PKCS7");
    padding2.init();

    int padCount = padding2.padCount(decBytes);

    print('pad cnt: ' + padCount.toString());

    //remove padding
    decBytes = decBytes.sublist(0, decBytes.lengthInBytes - padCount);

    print(Utils.hexEncode(decBytes));
    print(decBytes.length);

    return decBytes;
  }

  String get name => _name;

  DBChannel get dbChannel => _dbChannel;
}
