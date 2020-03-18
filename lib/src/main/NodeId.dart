import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

class NodeId {
  static final int PUBLIC_KEYLEN_LONG = 92;
  static final int PUBLIC_KEYLEN = 65;

  static Padding padding = new Padding("PKCS7");

  static final ECDomainParameters parameters = ECDomainParameters("brainpoolp256r1");

  AsymmetricKeyPair _keyPair;
  KademliaId _kademliaId;

  NodeId(this._keyPair);

  NodeId.withNewKeyPair() {
    _keyPair = generateECKeys();
  }

  /**
   * Exports the private point d of the curve.
   */
  Uint8List exportWithPrivate() {
    ECPrivateKey priv = _keyPair.privateKey;
    ECPublicKey pub = _keyPair.publicKey;

    var asn1Object = ASN1Sequence();
    asn1Object.add(ASN1Integer(priv.d));

    // GET the BER Stream
    var signatureBytes = asn1Object.encodedBytes;
    return signatureBytes;
  }

  /**
   * Imports the private key as asn1 encoded point d. The public key is computed from the private key.
   */
  NodeId.importWithPrivate(Uint8List bytes) {
    var asn1parser = ASN1Parser(bytes);
    ASN1Sequence asnObject = asn1parser.nextObject();

    ASN1Integer asn1d = asnObject.elements[0] as ASN1Integer;
    BigInt d = asn1d.valueAsBigInteger;

    //code to generate public Q is from ec_key_generator.dart:45
    var Q = parameters.G * d;

    _keyPair = new AsymmetricKeyPair(new ECPublicKey(Q, parameters), new ECPrivateKey(d, parameters));
  }

  Uint8List exportPublic() {
    ECPublicKey pubkey = _keyPair.publicKey;
    return exportPublicFromKey(pubkey);
  }

  static Uint8List exportPublicFromKey(ECPublicKey pubkey) {
    return pubkey.Q.getEncoded(false);
  }

  KademliaId getKademliaId() {
    _kademliaId ??= NodeId.fromPublicKey(_keyPair.publicKey);
    return _kademliaId;
  }

  AsymmetricKeyPair getKeyPair() {
    return _keyPair;
  }

  static KademliaId fromPublicKey(ECPublicKey key) {
    return KademliaId.fromFirstBytes(Utils.sha256(NodeId.exportPublicFromKey(key)));
  }

  static AsymmetricKeyPair generateECKeys() {
    final ECKeyGenerator generator = KeyGenerator("EC");
    generator.init(
      ParametersWithRandom(
        ECKeyGeneratorParameters(
          ECDomainParameters("brainpoolp256r1"),
        ),
        Utils.getSecureRandom(),
      ),
    );

    return generator.generateKeyPair();
  }

  NodeId.importPublic(Uint8List bytes) {
    ECPublicKey publicKey = bytesToPublicKey(bytes);
    _keyPair = new AsymmetricKeyPair(publicKey, null);
  }

  static ECPublicKey bytesToPublicKey(Uint8List bytes) {
    ECPoint Q = parameters.curve.decodePoint(bytes);
    return ECPublicKey(Q, parameters);
  }

  /**
   * Using SHA-256/DET-ECDSA, the signature is asn1 encoded with BigInt r and BigInt s.
   * Info: https://crypto.stackexchange.com/questions/1795/how-can-i-convert-a-der-ecdsa-signature-to-asn-1
   */
  Uint8List sign(Uint8List message) {
    final signer = Signer("SHA-256/DET-ECDSA");
    signer.init(
      true,
      PrivateKeyParameter(getKeyPair().privateKey),
    );
    final ECSignature sig = signer.generateSignature(message);

    var asn1Object = ASN1Sequence();
    asn1Object.add(ASN1Integer(sig.r));
    asn1Object.add(ASN1Integer(sig.s));

    // GET the BER Stream
    var signatureBytes = asn1Object.encodedBytes;
    return signatureBytes;
  }

  /**
   * Using SHA-256/DET-ECDSA, the signature has to be in asn1 format with BigInt r and BigInt s.
   * Info: https://crypto.stackexchange.com/questions/1795/how-can-i-convert-a-der-ecdsa-signature-to-asn-1
   */
  bool verify(Uint8List message, Uint8List signature) {
    var asn1parser = ASN1Parser(signature);
    ASN1Sequence asnObject = asn1parser.nextObject();

    ASN1Integer r = asnObject.elements[0] as ASN1Integer;
    ASN1Integer s = asnObject.elements[1] as ASN1Integer;
    var ecSignatureFromBytes = ECSignature(r.valueAsBigInteger, s.valueAsBigInteger);

    final verifier = Signer("SHA-256/DET-ECDSA");
    verifier.init(false, PublicKeyParameter(getKeyPair().publicKey));

    final isValid = verifier.verifySignature(message, ecSignatureFromBytes);
    return isValid;
  }

  /**
   * Equals operator checks for same bytes for the KademliaId.
   */
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NodeId && runtimeType == other.runtimeType && _kademliaId == other._kademliaId;

  @override
  int get hashCode => _kademliaId.hashCode;

  @override
  String toString() {
    return getKademliaId().toString();
  }
}
