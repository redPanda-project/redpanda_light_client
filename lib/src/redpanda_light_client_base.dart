// TODO: Put public facing types in this file.

import 'dart:convert';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/isolate_runner.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/kademlia/KadContent.dart';
import 'package:redpanda_light_client/src/redpanda_isolate.dart';

/// Checks if you are awesome. Spoiler: you are.
class RedPandaLightClient {
  static ConnectionService connectionService;
  static bool running = false;
  static final log = Logger('RedPandaLightClient');

//
// Method that sends a message to the new isolate
// and receives an answer
//
// In this example, I consider that the communication
// operates with Strings (sent and received data)
//
  static Future<dynamic> sendCommand(String command, [dynamic data]) async {
    //
    // We create a temporary port to receive the answer
    //
    ReceivePort port = ReceivePort();

    //
    // We send the message to the Isolate, and also
    // tell the isolate which port to use to provide
    // any answer
    //

    newIsolateSendPort.send(CrossIsolatesMessage<String>(sender: port.sendPort, message: command, data: data));

    //
    // Wait for the answer and return it
    //
    return port.first;
  }

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
    await setupAndStartIsolate();

    var data = {"dataFolderPath": dataFolderPath, "myPort": myPort};

    sendCommand(START, data);

//    Logger.root.level = Level.ALL; // defaults to Level.INFO
//    Logger.root.onRecord.listen((record) {
////      print('${record.level.name}: ${record.time}: ${record.message}');
//      print(
//          '${formatToMinLen(record.loggerName, 30)}: ${formatToMinLen(record.time.toString(), 26)}:    ${record.message}');
//    });
//
//    // create sqlite database folder otherwise the database opening will fail
//    // with: SqliteException: bad parameter or other API misuse, unable to open database file
////    if (Platform.isWindows) {
////    await new Directory('data').create(recursive: true);
////    }
//
//    if (running) {
//      log.info("RedPandaLightClient already running skipping new init...");
//      return;
//    }
//    running = true;
//
//    connectionService = ConnectionService(dataFolderPath, myPort);
//    await connectionService.start();
  }

  static Future<void> shutdown() async {
//    log.info("RedPandaLightClient shutting down...");
//    running = false;
//    await ConnectionService.appDatabase.close();
//    await connectionService.loopTimer.cancel();
//
//    for (Peer peer in PeerList.getList()) {
//      await peer.disconnect();
//    }
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
