import 'dart:io';
import 'dart:typed_data';

import 'package:moor/moor.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

AppDatabase appDatabase;

void main() {
  group('Test setup database', () {
    setUp(() async {
      ConnectionService.pathToDatabase = 'data';

      await new Directory(ConnectionService.pathToDatabase).create(recursive: true);

      appDatabase = new AppDatabase();
    });

    test('Test Channel create remove', () async {
      await appDatabase.createNewChannel("Name 1");


      var allChannels = await appDatabase.getAllChannels();

      var channel = new Channel(allChannels[0]);

      expect(channel.getNodeId() != null, true);
      expect(allChannels != null, true);

      await appDatabase.removeChannel(allChannels[0].id);
    });
  });
}
