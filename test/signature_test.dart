import 'dart:convert';
import 'dart:typed_data';

import 'package:moor/moor.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

void main() {
  group('Test basic Signature algorithm', () {
    setUp(() {});

    test('Test Signatures from NodeId Keypair', () {
      var nodeId = NodeId.withNewKeyPair();

      final Uint8List message = Utf8Codec().encode(
          "Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, Message to sign, ");

      final signer = Signer("SHA-256/DET-ECDSA");
      signer.init(
        true,
        PrivateKeyParameter(nodeId.getKeyPair().privateKey),
      );
      final ECSignature sig = signer.generateSignature(message);


      var asn1Object = ASN1Sequence();
      asn1Object.add(ASN1Integer(sig.r));
      asn1Object.add(ASN1Integer(sig.s));

      // GET the BER Stream
      var signatureBytes = asn1Object.encodedBytes;

      var asn1parser = ASN1Parser(signatureBytes);
      ASN1Sequence asnObject = asn1parser.nextObject();

      ASN1Integer r = asnObject.elements[0] as ASN1Integer;
      ASN1Integer s = asnObject.elements[1] as ASN1Integer;
      var ecSignatureFromBytes = ECSignature(r.valueAsBigInteger, s.valueAsBigInteger);


      final verifier = Signer("SHA-256/DET-ECDSA");
      verifier.init(false, PublicKeyParameter(nodeId.getKeyPair().publicKey));

      final isValid = verifier.verifySignature(message, ecSignatureFromBytes);
      print("isValid: $isValid");

      expect(isValid, true);
    });

    test('Test Signatures given from Java Code', () {
      var nodeId = NodeId.importPublic(Utils.hexDecode(
          "048f95dcfcf63d27d232074a9775d4225a7f14b659f759bf36f1880f37bc43e579500828281cae9d4fa6cbbea8f3bb9346b4cad29f905ad5b493e5e91439387d93"));

      final Uint8List message = Utils.hexDecode("54657374204d657373616765");

      var sig = Utils.hexDecode(
          "304402201d42817a53bc0bcb83c554995549ea46e1365450f9b2e2fcd6a77146134e9bfe02207a380ebebc6e3a50609aa4727db3bcc92b206777002f2a503d53f08bafc7b4f7");

      final verifier = Signer("SHA-256/DET-ECDSA");
      verifier.init(false, PublicKeyParameter(nodeId.getKeyPair().publicKey));

      var asn1parser = ASN1Parser(sig);

      ASN1Sequence asnObject = asn1parser.nextObject();

      ASN1Integer r = asnObject.elements[0] as ASN1Integer;
      ASN1Integer s = asnObject.elements[1] as ASN1Integer;

      var ecSignature = ECSignature(r.valueAsBigInteger, s.valueAsBigInteger);

      final isValid = verifier.verifySignature(message, ecSignature);
      print("isValid: $isValid");

      expect(isValid, true);
    });
  });
}
