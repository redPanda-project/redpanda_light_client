//import 'package:crypto/crypto.dart';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/redpanda_light_client.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
//    RedPandaLightClient awesome;

    setUp(() {
//      RedPandaLightClient.init(new KademliaId());
    });

    test('Test Hex and Sha', () {
      Uint8List sha256 = Utils.sha256(Utils.hexDecode(
          "0437fb5ab1b9c42505c6fff4fd9a01e8aecf52fd51e3562c5769246587d36a179f95c2748f432c508f10a3a8edf6eb12d2c3367c147892e176c5c4e0bfd2b38c9a"));

      expect(Utils.hexEncode(sha256),
          "bbab08ebe50a7b27705212eec59cd6fa62f5dff7ee14d2e7b95c3f6eb9f82aa8");
    });

  });
}
