import 'dart:io';

import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

AppDatabase appDatabase;

void main() {
  group('Test setup database', () {
    setUp(() async {
      if (ConnectionService.appDatabase == null) {
        ConnectionService.pathToDatabase = 'data';
        await new Directory(ConnectionService.pathToDatabase).create(recursive: true);
        appDatabase = new AppDatabase();
        ConnectionService.appDatabase = appDatabase;
      } else {
        appDatabase = ConnectionService.appDatabase;
      }
    });

    test('Test DBPeers', () async {
      var nodeId = new NodeId.withNewKeyPair();

      await appDatabase.dBPeersDao.insertNewPeer("127.0.0.1", 1332, nodeId.getKademliaId(), nodeId.exportPublic());

      var dbPeer = await appDatabase.dBPeersDao.getPeerByKademliaId(nodeId.getKademliaId());

      expect(dbPeer != null, true);

      await appDatabase.dBPeersDao.removePeerByKademliaId(nodeId.getKademliaId());

      var dbPeer2 = await appDatabase.dBPeersDao.getPeerByKademliaId(nodeId.getKademliaId());

      expect(dbPeer2 == null, true);
    });

    test('Test Channel create remove', () async {
      await appDatabase.createNewChannel("Name 1");

      var allChannels = await appDatabase.getAllChannels();

      var channel = new Channel(allChannels[0]);

      expect(channel.getNodeId() != null, true);
      expect(allChannels != null, true);

      await appDatabase.removeChannel(allChannels[0].id);
    });

    test('Test Channel data', () async {
      await appDatabase.createNewChannel("Name 1");

      var allChannels = await appDatabase.getAllChannels();

      var channel = new Channel(allChannels[0]);

      Map<String, dynamic> data = channel.getChannelData();

      data["test"] = 5;

      print(data);

      await channel.saveChannelData();

      for (DBChannel c in await appDatabase.getAllChannels()) {
        print("${c.id} ${c.channelData}");
      }

//      var string = '{"test": 5, "users": ["a", "b"], "hm": {"a": "a1", "b": "b1"}}';
//      print(jsonDecode(string).runtimeType);
//      print(jsonDecode(string));
//      print(jsonDecode(string)["hm"]);
//
//      var obj = jsonDecode(string);
//
//      print(obj.runtimeType);
//
//      obj["unexistend"] = "a";
//
//
//      var testMap = {"tm": 6};
//
//      obj["unexistend2"] = testMap;
//
//      print(jsonEncode(obj));
//
//
//      print(jsonDecode(jsonEncode(obj)));
//
//      print(jsonEncode(jsonDecode(jsonEncode(obj))));
    });


    test('Test MaintainChannels', () async {
      await ConnectionService.setupLocalSettings();

      await appDatabase.createNewChannel("Name 1");

      await RedPandaLightClient.maintain();
    });

    test('Test Channel AES Block Cipher implementation', () async {
      var appDatabase = ConnectionService.appDatabase;
      var allChannels = await appDatabase.getAllChannels();

      if (allChannels.isEmpty) {
        await appDatabase.createNewChannel("Name 1");
        allChannels = await appDatabase.getAllChannels();
      }

      var channel = new Channel(allChannels[0]);

      print(channel);

      var iv = Utils.randBytes(16);

      ByteBuffer b = ByteBuffer(2);

      b.writeByte(8);
      b.writeByte(125);

      var encryptAES = channel.encryptAES(b.array(), iv);

      var decryptAES = channel.decryptAES(encryptAES, iv);

      expect(decryptAES.length, b.length);
      expect(ByteBuffer.fromList(decryptAES).readByte(), 8);
    });
  });
}
