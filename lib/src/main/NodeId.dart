import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

class NodeId {
  AsymmetricKeyPair _keyPair;
  KademliaId _kademliaId;

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

  static KademliaId fromPublicKey(ECPublicKey key) {
    return KademliaId.fromFirstBytes(
        Utils.sha256(NodeId.exportPublicFromKey(key)));
  }
}
