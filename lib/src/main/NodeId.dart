import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

class NodeId {
  static final int PUBLIC_KEYLEN_LONG = 92;
  static final int PUBLIC_KEYLEN = 65;

  static final ECDomainParameters parameters =
      ECDomainParameters("brainpoolp256r1");

  AsymmetricKeyPair _keyPair;
  KademliaId _kademliaId;

  NodeId(this._keyPair);

  NodeId.withNewKeyPair() {
    _keyPair = generateECKeys();
    ECPrivateKey priv = _keyPair.privateKey;
    BigInt i = priv.d;
    String radixString = i.toRadixString(16);
    print(radixString);
    print(i.toString());
    BigInt parse = BigInt.parse(radixString, radix: 16);
    print(i.toString());
    print(parse.toString());

    ECPrivateKey ecPrivateKey = ECPrivateKey(parse, parameters);
  }

  String exportWithPrivate() {
    ECPrivateKey priv = _keyPair.privateKey;
    String privString = priv.d.toRadixString(16);
    String pubString = Utils.base58encode(exportPublic());
    return privString + "," + pubString;
  }

  NodeId.importWithPrivate(String string) {
    List<String> split = string.split(",");

    String privString = split[0];
    String pubString = split[1];

    BigInt parse = BigInt.parse(privString, radix: 16);
    ECPrivateKey privateKey = ECPrivateKey(parse, parameters);

    ECPublicKey publicKey = bytesToPublicKey(Utils.base58decode(pubString));

    _keyPair = new AsymmetricKeyPair(publicKey, privateKey);
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
    return KademliaId.fromFirstBytes(
        Utils.sha256(NodeId.exportPublicFromKey(key)));
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
   * Equals operator checks for same bytes for the KademliaId.
   */
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeId &&
          runtimeType == other.runtimeType &&
          _kademliaId == other._kademliaId;

  @override
  int get hashCode => _kademliaId.hashCode;

  @override
  String toString() {
    return getKademliaId().toString();
  }
}
