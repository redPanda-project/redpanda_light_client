// TODO: Put public facing types in this file.

import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/kademlia/KadContent.dart';

/// Checks if you are awesome. Spoiler: you are.
class RedPandaLightClient {
  static ConnectionService connectionService;
  static bool running = false;
  static final log = Logger('RedPandaLightClient');

  static String formatToMinLen(String s, int len) {
    int toAdd = len - s.length;
    if (toAdd < 1) {
      return s;
    }

    for (int i = 0; i < toAdd; i++) {
      s += " ";
    }
    return s;
  }

  static Future<void> init(String dataFolderPath, int myPort) async {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
//      print('${record.level.name}: ${record.time}: ${record.message}');
      print(
          '${formatToMinLen(record.loggerName, 30)}: ${formatToMinLen(record.time.toString(), 26)}:    ${record.message}');
    });

    // create sqlite database folder otherwise the database opening will fail
    // with: SqliteException: bad parameter or other API misuse, unable to open database file
//    if (Platform.isWindows) {
//    await new Directory('data').create(recursive: true);
//    }

    if (running) {
      log.info("RedPandaLightClient already running skipping new init...");
      return;
    }
    running = true;

    connectionService = ConnectionService(dataFolderPath, myPort);
    await connectionService.start();
  }

  static Future<void> shutdown() async {
    log.info("RedPandaLightClient shutting down...");
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

      log.finest("chan object[${dbChannel.id}]: ${dbChannel.channelData}");

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

      bool updated = false;

      if (userData == null) {
//        print('no userdata found from us...');

        channel.setUserData(myUserId, myUserdata);
        await channel.saveChannelData();
        updated = true;
      } else {
//        print('found userdata');
        int generated = userData['generated'];
        if (Utils.getCurrentTimeMillis() - generated > 1000 * 10) {
//          print('found userdata is too old...');
          channel.setUserData(myUserId, myUserdata);
          await channel.saveChannelData();
          updated = true;
        }
      }

      if (updated) {
        String channelDataString = jsonEncode(channel.getChannelData());
        var channelDataStringBytes = Utils.encodeUTF8(channelDataString);

        KadContent kadContent = new KadContent.createNow(channel.getNodeId().exportPublic(), channelDataStringBytes);

        kadContent.encryptWith(channel);

        kadContent.signWith(channel.getNodeId());

        PeerList.sendIntegrated(kadContent.toCommand());
        log.finest("send to integrated....");
      }

      log.finest("");
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
