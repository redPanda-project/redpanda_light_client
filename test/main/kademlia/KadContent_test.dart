import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/kademlia/KadContent.dart';
import 'package:test/test.dart';

AppDatabase appDatabase;

void main() {
  group('Test setup', () {
    setUp(() async {});

    test('Test KadContent create sign verify', () async {
      var nodeId = new NodeId.withNewKeyPair();

      var byteBuffer = ByteBuffer(8);

      var kadContent = new KadContent.createNow(nodeId.exportPublic(), byteBuffer.array());
      var kadContentOld = new KadContent(0, nodeId.exportPublic(), byteBuffer.array());

      expect(kadContent.getKademliaId() != null, true);

      expect(kadContent.getKademliaId() != kadContentOld.getKademliaId(), true);

      var channel = new Channel.newWithName("name");

      channel.dbChannel = new DBChannel(id: null, name: null, sharedSecret: Utils.randBytes(32), nodeId: null);

      await kadContent.encryptWith(channel);

      await kadContent.signWith(nodeId);

      expect(kadContent.verify(), true);

      await kadContent.decryptWith(channel);

      expect(Utils.listsAreEqual(byteBuffer.array(), kadContent.getContent()), true);
    });
  });
}
