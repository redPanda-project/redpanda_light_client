import 'dart:typed_data';

import 'package:moor/moor.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

AppDatabase appDatabase;

void main() {
  group('Test PeerList', () {
    test('Test insert without id', () {
      var peer = new Peer("123333", 1234);

      PeerList.add(peer);
      PeerList.add(peer);

      expect(PeerList.size(), 1);

      PeerList.remove(peer);

      expect(PeerList.size(), 0);
    });

    test('Test insert', () {
      var peer = new Peer("123333", 1234);
      peer.setNodeId(new NodeId.withNewKeyPair());

      PeerList.add(peer);
      PeerList.add(peer);

      expect(PeerList.size(), 1);

      PeerList.remove(peer);

      expect(PeerList.size(), 0);
    });

    test('Test insert with different ip and port', () {

      var nodeId = new NodeId.withNewKeyPair();

      var peer = new Peer("542342342", 4234);
      peer.setNodeId(nodeId);

      expect(peer.getKademliaId() != null, true);

      var peer2 = new Peer("123333", 1234);
      peer2.setNodeId(nodeId);

      PeerList.add(peer);
      PeerList.add(peer2);

      expect(PeerList.size(), 1);

      PeerList.remove(peer);

      expect(PeerList.size(), 0);
    });
  });
}
