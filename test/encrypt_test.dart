import 'dart:typed_data';

import 'package:moor/moor.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

void main() {
  group('Test basic encryption', () {
    setUp(() {});

    test('Test enc', () {
      AESFastEngine aes = AESFastEngine();

      CTRStreamCipher ctrStreamCipher = CTRStreamCipher(aes);

      ParametersWithIV parametersWithIV = ParametersWithIV(
          KeyParameter(Utils.randBytes(32)), Utils.randBytes(16));

      ctrStreamCipher.init(true, parametersWithIV);

      ByteBuffer b = ByteBuffer(1);

      Uint8List encBytes = ctrStreamCipher.process(b.readBytes(b.remaining()));
      print("enc byte: " + Utils.hexEncode(encBytes));

      CTRStreamCipher dec = CTRStreamCipher(aes);
      dec.init(false, parametersWithIV);

      Uint8List decBytes =  dec.process(encBytes);


      print(Utils.hexEncode(decBytes));
      print(decBytes.length);

      ByteBuffer buffer = ByteBuffer.fromBuffer(decBytes.buffer);

      expect(decBytes.length, 1);
      expect(buffer.readByte(), 0);



    });
  });
}
