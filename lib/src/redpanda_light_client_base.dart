// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';

/// Checks if you are awesome. Spoiler: you are.
class RedPandaLightClient {
  static List<Channel> _channels;

  static ConnectionService connectionService;

  static Future<void> init(String dataFolderPath) async {
    // create sqlite database folder otherwise the database opening will fail
    // with: SqliteException: bad parameter or other API misuse, unable to open database file
//    if (Platform.isWindows) {
//    await new Directory('data').create(recursive: true);
//    }

    connectionService = ConnectionService(dataFolderPath);
    await connectionService.start();
    print('db: ' + ConnectionService.appDatabase.toString());
  }

  static Future<void> shutdown() async {
    ConnectionService.appDatabase.close();
    connectionService.loopTimer.cancel();
  }

//  static List<Channel> getChannels() {
//    if (_channels == null) {
//      _channels = new List<Channel>();
//      _channels.add(new Channel("Name 1"));
//      _channels.add(new Channel("Name 2"));
//    }
//
//    return _channels;
//  }
}
