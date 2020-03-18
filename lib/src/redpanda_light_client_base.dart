// TODO: Put public facing types in this file.

import 'dart:collection';

import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

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

  static Future<void> maintain() async {
    var appDatabase = ConnectionService.appDatabase;

    LocalSetting localSettings = await appDatabase.getLocalSettings;

    Map<String, dynamic> myUserdata = await generateMyUserData(localSettings);

    List<DBChannel> allChannels = await appDatabase.getAllChannels();

    print('channels: ' + allChannels.length.toString());

    String myUserId = localSettings.myUserId;

    for (DBChannel dbChannel in await allChannels) {
      Channel channel = new Channel(dbChannel);

      Map<String, dynamic> channelData = channel.getChannelData();

      print("chan object[${dbChannel.id}]: ${dbChannel.channelData}");

      if (channelData == null) {
        continue;
      }

      Map<String, dynamic> userData = null;
      Map<String, dynamic> channelData2 = channelData['userdata'];

      if (channelData2 != null) {
        userData = channelData2[myUserId];
      } else {
        channelData['userdata'] = {};
      }

      if (userData == null) {
        print('no userdata found from us...');

        channel.setUserData(myUserId, myUserdata);
        await channel.saveChannelData();
      } else {
        print('found userdata');
        int generated = userData['generated'];
        if (Utils.getCurrentTimeMillis() - generated > 1000 * 10) {
          print('found userdata is too old...');
          channel.setUserData(myUserId, myUserdata);
          await channel.saveChannelData();
        }
      }

      print("");
    }
  }

  static Map<String, dynamic> generateMyUserData(LocalSetting localSettings) {
    var data = {"nick": localSettings.defaultName, "generated": Utils.getCurrentTimeMillis()};
    return data;
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
