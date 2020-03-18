import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:moor/moor.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ChannelData.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
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

      var data = channel.getChannelData();

      print(data);

      print(ChannelData().encodeToJson());

      String encodeToJson = ChannelData().encodeToJson();

      ChannelData decodeToJson = ChannelData.decodeToJson(encodeToJson);

      expect(decodeToJson.encodeToJson(), encodeToJson);
    });

    test('Test Channel data with storing', () async {
      await appDatabase.createNewChannel("Name 1");

      var allChannels = await appDatabase.getAllChannels();

      var channel = new Channel(allChannels[0]);

      var data = channel.getChannelData();

      data.group = true;

      channel.saveChannelData();

      var dbChannel = await appDatabase.getChannelById(channel.getId());
      var channel2 = new Channel(dbChannel);

      expect(channel2.getChannelData().group, true);
    });
  });
}
