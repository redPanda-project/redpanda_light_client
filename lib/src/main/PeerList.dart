import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';

class PeerList {
  static final log = Logger('PeerList');
  static final HashMap<KademliaId, Peer> _hashMap = HashMap<KademliaId, Peer>();
  static final HashMap<int, Peer> _hashMapIpPort = HashMap<int, Peer>();
  static final List<Peer> _peerlist = [];

  static bool add(Peer peer) {
    if (peer.getKademliaId() != null) {
      KademliaId kademliaId = peer.getKademliaId();

      bool containsKey = _hashMap.containsKey(kademliaId);

      if (!containsKey) {
        log.finest('new peer which was not in our list....');
        _hashMap.putIfAbsent(kademliaId, () => peer);
        _hashMapIpPort.update(peer.getIpPortHash(), (oldPeer) => peer, ifAbsent: () => peer);
        _peerlist.add(peer);
        return true;
      } else {
        return false;
      }
    } else {
      if (!_hashMapIpPort.containsKey(peer.getIpPortHash())) {
        _hashMapIpPort.putIfAbsent(peer.getIpPortHash(), () => peer);
        _peerlist.add(peer);
        return true;
      } else {
        return false;
      }
    }
  }

  static bool remove(Peer peer) {
    var remove2 = _peerlist.remove(peer);
    _hashMapIpPort.remove(peer.getIpPortHash());

    if (peer.getKademliaId() == null) {
      return remove2 != null;
    }
    KademliaId kademliaId = peer.getNodeId().getKademliaId();

    var remove = _hashMap.remove(kademliaId);

    return remove != null;
  }

  static int length() {
    return _peerlist.length;
  }

  static List<Peer> getList() {
    return _peerlist;
  }
}
