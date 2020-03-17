import 'dart:convert';
import 'dart:typed_data';

import 'package:moor/moor.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

void main() {
  group('Test basic Signature algorithm', () {
    setUp(() {});

    test('Test Signatures from NodeId Keypair', () {
      var nodeId = NodeId.withNewKeyPair();

      final Uint8List message = Utf8Codec().encode("Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, ");

      final signer = Signer("SHA-256/DET-ECDSA");
      signer.init(
        true,
        PrivateKeyParameter(nodeId.getKeyPair().privateKey),
      );
      final ECSignature sig = signer.generateSignature(message);

      final verifier = Signer("SHA-256/DET-ECDSA");
      verifier.init(false, PublicKeyParameter(nodeId.getKeyPair().publicKey));

      final isValid = verifier.verifySignature(message, sig);
      print("isValid: $isValid");

      expect(isValid, true);
    });
  });
}
