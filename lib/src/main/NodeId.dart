import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

class NodeId {
  static final int PUBLIC_KEYLEN_LONG = 92;
  static final int PUBLIC_KEYLEN = 65;

  AsymmetricKeyPair _keyPair;
  KademliaId _kademliaId;

  NodeId(this._keyPair);

  NodeId.withNewKeyPair() {
    _keyPair = generateECKeys();
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

  static NodeId importPublic(Uint8List bytes) {
    ECDomainParameters parameters = ECDomainParameters("brainpoolp256r1");
    ECPoint Q = parameters.curve.decodePoint(bytes);
    ECPublicKey publicKey = ECPublicKey(Q, parameters);

    AsymmetricKeyPair keyPair = new AsymmetricKeyPair(publicKey, null);
    NodeId nodeId = new NodeId(keyPair);
    return nodeId;

//    ECCurveBase(parameters.curve.a.toBigInteger(),parameters.curve.b.toBigInteger());
//
//    ECCurve()
//
//    ECCurveBase.decodePoint(bytes.toList());

//    final ECKeyGenerator generator = KeyGenerator("EC");
//    generator.init(Parameters
//      ParametersWithRandom(
//        ECKeyGeneratorParameters(
//          ECDomainParameters("brainpoolp256r1"),
//        ),
//        Utils.getSecureRandom(),
//      ),
//    );

//  byte[] bytesFull = new byte[PUBLIC_KEYLEN_LONG];
//  ByteBuffer.wrap(bytesFull)
//      .put(getCurveParametersForASN1Format())
//      .put(bytes);
//
//
//  EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(bytesFull);
//
//  KeyFactory keyFactory = null;
//  try {
//  keyFactory = KeyFactory.getInstance("ECDH", "BC");
//  PublicKey newPublicKey = keyFactory.generatePublic(publicKeySpec);
//
//  KeyPair keyPair = new KeyPair(newPublicKey, null);
//  return new NodeId(keyPair);
//  } catch (NoSuchAlgorithmException e) {
//  e.printStackTrace();
//  } catch (NoSuchProviderException e) {
//  e.printStackTrace();
//  } catch (InvalidKeySpecException e) {
//  e.printStackTrace();
//  }

//  return null;
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
