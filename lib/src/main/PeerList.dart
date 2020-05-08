import 'dart:async';
import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';

class PeerList {
  static final log = Logger('PeerList');
  static final HashMap<KademliaId, Peer> _hashMap = HashMap<KademliaId, Peer>();
  static final HashMap<int, Peer> _hashMapIpPort = HashMap<int, Peer>();
  static final List<Peer> _peerlist = <Peer>[];

  static bool add(Peer peer) {
    if (peer.getKademliaId() != null) {
      KademliaId kademliaId = peer.getKademliaId();

      bool containsKey = _hashMap.containsKey(kademliaId);

      if (!containsKey) {
        log.finest('new peer which was not in our list, at least not in the Kademlia list...');
        _hashMap.putIfAbsent(kademliaId, () => peer);
        _hashMapIpPort.update(peer.getIpPortHash(), (oldPeer) => peer, ifAbsent: () => peer);
        _peerlist.add(peer);
        ConnectionService.appDatabase.dBPeersDao
            .insertNewPeer(peer.ip, peer.port, peer.getKademliaId(), publicKey: peer.getNodeId()?.exportPublic());
        return true;
      } else {
        return false;
      }
    } else {
      if (!_hashMapIpPort.containsKey(peer.getIpPortHash())) {
        //new peer which was known only by ip and port not by KademliaId
        _hashMapIpPort.putIfAbsent(peer.getIpPortHash(), () => peer);
        _peerlist.add(peer);
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<bool> remove(Peer peer) async {
    var remove2 = _peerlist.remove(peer);
    _hashMapIpPort.remove(peer.getIpPortHash());

    if (peer.getKademliaId() == null) {
      return remove2 != null;
    }
    KademliaId kademliaId = peer.getKademliaId();

    var remove = _hashMap.remove(kademliaId);

    return remove != null;
  }

  static int size() {
    return _peerlist.length;
  }

  static List<Peer> getList() {
    return _peerlist;
  }

  static void sendIntegrated(ByteBuffer bytes) async {
    for (Peer p in _peerlist) {
      if (p.connected && p.socket != null) {
        bool send = false;
        await runZoned<Future<void>>(() async {
          await p.sendEncrypt(bytes);
          log.finer("send to: " + p.getKademliaId().toString());
          send = true;
        }, onError: (error, stackTrace) {
          print("error sending message... " + error.toString() + " " + p.getKademliaId().toString());
        });
        if (send) {
          return;
        } else {
          print("send failed use another peer...");
        }
      }
    }
  }

  static Future<void> updateKademliaId(Peer peer, KademliaId oldId, KademliaId newId) async {
    _hashMap.remove(oldId);
    _hashMap.putIfAbsent(newId, () => peer);
    await ConnectionService.appDatabase.dBPeersDao
        .insertNewPeer(peer.ip, peer.port, peer.getKademliaId(), publicKey: peer.getNodeId()?.exportPublic());
    return;
  }


}
