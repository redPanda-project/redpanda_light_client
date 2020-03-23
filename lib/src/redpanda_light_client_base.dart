// TODO: Put public facing types in this file.

import 'dart:async';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/store/DBMessageWithFriend.dart';
import 'package:redpanda_light_client/src/main/store/DBMessagesDao.dart';
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

    print(newIsolateSendPort);
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
    return sendCommand(START, data);
  }

  static Future<void> initForDebug(String dataFolderPath, int myPort) async {
    await setupAndStartIsolate();
    var data = {"dataFolderPath": dataFolderPath, "myPort": myPort};
    return sendCommand(START_DEBUG, data);
  }

  /**
   * Creates a new Channel with the given name. Returns the new Channel Id.
   */
  static Future<void> createNewChannel(String name) async {
    var data = {"name": name};
    return sendCommand(CHANNEL_CREATE, data);
  }

  static Future<void> renameChannel(int channelId, String newName) async {
    var data = {"channelId": channelId, "newName": newName};
    return sendCommand(CHANNEL_RENAME, data);
  }

  static Future<void> removeChannel(int channelId) async {
    var data = {"channelId": channelId};
    return sendCommand(CHANNEL_REMOVE, data);
  }

  static Future<dynamic> getChannelById(int channelId) async {
    var data = {"channelId": channelId};
    return sendCommand(CHANNEL_GET_BY_ID, data);
  }

  static Stream<List<DBChannel>> watchDBChannelEntries() async* {
    ReceivePort port = ReceivePort();
    newIsolateSendPort.send(CrossIsolatesMessage<String>(sender: port.sendPort, message: CHANNELS_WATCH));

    await for (List<DBChannel> a in port) {
      yield a;
    }
  }

  static Stream<List<DBMessageWithFriend>> watchDBMessageEntries(int channelId) async* {
    print("watchDBMessageEntries");
    var data = {"channelId": channelId};
    ReceivePort port = ReceivePort();
    newIsolateSendPort.send(CrossIsolatesMessage<String>(sender: port.sendPort, message: MESSAGES_WATCH, data: data));

    print("awaiting messages...");

    await for (List<DBMessageWithFriend> a in port) {
      print("pushing messages...");
      yield a;
    }
  }

  static Future<void> writeMessage(int channelId, String text) async {
    var data = {"channelId": channelId, "text": text};
    return sendCommand(MESSAGES_SEND, data);
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
