// TODO: Put public facing types in this file.

import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';

/// Checks if you are awesome. Spoiler: you are.
class RedPandaLightClient {
  static ConnectionService connectionService;
  static bool running = false;

  static Future<void> init(String dataFolderPath, int myPort) async {
    // create sqlite database folder otherwise the database opening will fail
    // with: SqliteException: bad parameter or other API misuse, unable to open database file
//    if (Platform.isWindows) {
//    await new Directory('data').create(recursive: true);
//    }

    if (running) {
      print("RedPandaLightClient already running skipping new init...");
      return;
    }
    running = true;

    connectionService = ConnectionService(dataFolderPath, myPort);
    await connectionService.start();
    print('db: ' + ConnectionService.appDatabase.toString());
  }

  static Future<void> shutdown() async {
    print("RedPandaLightClient shutting down...");
    running = false;
    await ConnectionService.appDatabase.close();
    await connectionService.loopTimer.cancel();

    for (Peer peer in PeerList.getList()) {
      await peer.disconnect();
    }
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
