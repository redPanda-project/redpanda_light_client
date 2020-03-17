import 'dart:typed_data';

import 'package:moor/moor.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

void main() {
  group('Test basic encryption', () {
    setUp(() {});

    test('Test enc Cipher Stream CTR', () {
      AESFastEngine aes = AESFastEngine();

      CTRStreamCipher ctrStreamCipher = CTRStreamCipher(aes);

      ParametersWithIV parametersWithIV = ParametersWithIV(KeyParameter(Utils.randBytes(32)), Utils.randBytes(16));

      ctrStreamCipher.init(true, parametersWithIV);

      ByteBuffer b = ByteBuffer(1);

      Uint8List encBytes = ctrStreamCipher.process(b.readBytes(b.remaining()));
      print("enc byte: " + Utils.hexEncode(encBytes));

      CTRStreamCipher dec = CTRStreamCipher(aes);
      dec.init(false, parametersWithIV);

      Uint8List decBytes = dec.process(encBytes);

      print(Utils.hexEncode(decBytes));
      print(decBytes.length);

      ByteBuffer buffer = ByteBuffer.fromBuffer(decBytes.buffer);

      expect(decBytes.length, 1);
      expect(buffer.readByte(), 0);
    });

    test('Test enc Blockcipher', () {
      var cbcBlockCipher = CBCBlockCipher(AESFastEngine());

      ParametersWithIV parametersWithIV = ParametersWithIV(KeyParameter(Utils.randBytes(32)), Utils.randBytes(16));

      cbcBlockCipher.init(true, parametersWithIV);

      ByteBuffer b = ByteBuffer(2);

      b.writeByte(8);
      b.writeByte(125);

      int bytesWithFullBlock = 16 - b.length % 16;

      print(b.length + bytesWithFullBlock);

      var paddedBuffer = ByteBuffer(b.length + bytesWithFullBlock);
      paddedBuffer.writeBytes(b);

      var padding = new Padding("PKCS7");
      padding.init();

      padding.addPadding(paddedBuffer.array(), b.offset);

      Uint8List encBytes = cbcBlockCipher.process(paddedBuffer.array());
      print("enc byte: " + Utils.hexEncode(encBytes));

      var dec = CBCBlockCipher(AESFastEngine());
      dec.init(false, parametersWithIV);

      Uint8List decBytes = dec.process(encBytes);

      var padding2 = new Padding("PKCS7");
      padding2.init();

      int padCount = padding2.padCount(decBytes);

      print('pad cnt: ' + padCount.toString());

      //remove padding
      decBytes = decBytes.sublist(0, decBytes.lengthInBytes - padCount);

      print(Utils.hexEncode(decBytes));
      print(decBytes.length);

      ByteBuffer buffer = ByteBuffer.fromBuffer(decBytes.buffer);

      expect(decBytes.length, b.length);
      expect(buffer.readByte(), 8);
    });

    test('Test Channel AES Block Cipher implementation', () async {
      ConnectionService.pathToDatabase = 'data';

      var appDatabase = new AppDatabase();

      var getRandomChannel = await appDatabase.getRandomDBChannel;

      if (getRandomChannel == null) {
        await appDatabase.createNewChannel("Name 1");
        getRandomChannel = await appDatabase.getRandomDBChannel;
      }

      var channel = new Channel(getRandomChannel);

      print(channel);

      var iv = Utils.randBytes(16);

      ByteBuffer b = ByteBuffer(2);

      b.writeByte(8);
      b.writeByte(125);

      var encryptAES = channel.encryptAES(b.array(), iv);

      var decryptAES = channel.decryptAES(encryptAES, iv);

      expect(decryptAES.length, b.length);
      expect(ByteBuffer.fromList(decryptAES).readByte(), 8);
    });
  });
}
