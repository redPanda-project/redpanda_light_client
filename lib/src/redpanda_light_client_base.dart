// TODO: Put public facing types in this file.

import 'dart:async';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/IsolateCommand.dart';
import 'package:redpanda_light_client/src/main/store/DBMessageWithFriend.dart';
import 'package:redpanda_light_client/src/main/store/DBMessagesDao.dart';
import 'package:redpanda_light_client/src/redpanda_isolate.dart';

/// Checks if you are awesome. Spoiler: you are.
class RedPandaLightClient {
  static ConnectionService connectionService;
  static bool running = false;
  static final log = Logger('RedPandaLightClient');
  static Function onNewMessage;
  static Function onNewStatus;

//
// Method that sends a message to the new isolate
// and receives an answer
//
// In this example, I consider that the communication
// operates with Strings (sent and received data)
//
  static Future<dynamic> sendCommand(IsolateCommand command, [dynamic data]) async {
    if (newIsolateSendPort == null) {
      print("called command to RPC before starting the isolate...");
      return;
    }

    //
    // We create a temporary port to receive the answer
    //
    ReceivePort port = ReceivePort();

    //
    // We send the message to the Isolate, and also
    // tell the isolate which port to use to provide
    // any answer
    //

//    print(newIsolateSendPort);
    newIsolateSendPort.send(CrossIsolatesMessage<IsolateCommand>(sender: port.sendPort, message: command, data: data));

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
    running = true;
    await setupAndStartIsolate();

    var recPortOnExit = new ReceivePort();
    recPortOnExit.listen((message) {
      print("OnExitListener: " + message.toString());
      running = false;
    });
    newIsolate.addOnExitListener(recPortOnExit.sendPort);

    var data = {"dataFolderPath": dataFolderPath, "myPort": myPort};

    startOnNewMessageListener();
    startOnNewStatusListener();

    new Timer.periodic(Duration(seconds: 1), (t) {
      sendCommand(IsolateCommand.PING);
    });
    print("starting ping");

    return sendCommand(IsolateCommand.START, data);
  }

  static Future<void> initForDebug(String dataFolderPath, int myPort) async {
    await setupAndStartIsolate();
    var data = {"dataFolderPath": dataFolderPath, "myPort": myPort};
    return sendCommand(IsolateCommand.START_DEBUG, data);
  }

  /**
   * Creates a new Channel with the given name. Returns the new Channel Id.
   */
  static Future<void> createNewChannel(String name) async {
    var data = {"name": name};
    return sendCommand(IsolateCommand.CHANNEL_CREATE, data);
  }

  static Future<void> channelFromData(String name, String dataString) async {
    var data = {"data": dataString, "name": name};
    return sendCommand(IsolateCommand.CHANNEL_FROM_DATA, data);
  }

  static Future<void> renameChannel(int channelId, String newName) async {
    newName = newName.trim();
    var data = {"channelId": channelId, "newName": newName};
    return sendCommand(IsolateCommand.CHANNEL_RENAME, data);
  }

  static Future<void> removeChannel(int channelId) async {
    var data = {"channelId": channelId};
    return sendCommand(IsolateCommand.CHANNEL_REMOVE, data);
  }

  static Future<dynamic> getChannelById(int channelId) async {
    var data = {"channelId": channelId};
    return sendCommand(IsolateCommand.CHANNEL_GET_BY_ID, data);
  }

  static Stream<List<DBChannel>> watchDBChannelEntries() async* {
    ReceivePort port = ReceivePort();
    newIsolateSendPort
        .send(CrossIsolatesMessage<IsolateCommand>(sender: port.sendPort, message: IsolateCommand.CHANNELS_WATCH));

    await for (List<DBChannel> a in port) {
      yield a;
    }
  }

  static Stream<List<DBMessageWithFriend>> watchDBMessageEntries(int channelId) async* {
    print("watchDBMessageEntries");
    var data = {"channelId": channelId};
    ReceivePort port = ReceivePort();
    newIsolateSendPort.send(CrossIsolatesMessage<IsolateCommand>(
        sender: port.sendPort, message: IsolateCommand.MESSAGES_WATCH, data: data));

    print("awaiting messages...");

    await for (List<DBMessageWithFriend> a in port) {
      print("pushing messages...");
      yield a;
    }
  }

  static Future<List<DBMessageWithFriend>> getAllMessages(int channelId) async {
    print("getDBMessageEntries");
    var data = {"channelId": channelId};
    return sendCommand(IsolateCommand.MESSAGES_GET_RECENT, data);
  }

  static Future<void> writeMessage(int channelId, String text) async {
    var data = {"channelId": channelId, "text": text};
    return sendCommand(IsolateCommand.MESSAGES_SEND, data);
  }

  static Future<void> shutdown() async {
    await sendCommand(IsolateCommand.SHUTDOWN);
//    log.info("RedPandaLightClient shutting down...");
//    running = false;
//    await ConnectionService.appDatabase.close();
//    await connectionService.loopTimer.cancel();
//
//    for (Peer peer in PeerList.getList()) {
//      await peer.disconnect();
//    }
  }

  static void startOnNewMessageListener() async {
    print("startOnNewMessageListener");
    ReceivePort port = ReceivePort();
    newIsolateSendPort
        .send(CrossIsolatesMessage<IsolateCommand>(sender: port.sendPort, message: IsolateCommand.MESSAGES_LISTEN_NEW));

    print("awaiting messages...");

    await for (DBMessageWithFriend newMsg in port) {
      if (onNewMessage != null) {
        onNewMessage(newMsg);
      }
    }
  }

  static void startOnNewStatusListener() async {
    print("startOnNewStatusListener");
    ReceivePort port = ReceivePort();
    newIsolateSendPort
        .send(CrossIsolatesMessage<IsolateCommand>(sender: port.sendPort, message: IsolateCommand.STATUS_LISTEN));

    print("awaiting status...");

    await for (String newMsg in port) {
      if (onNewStatus != null) {
        onNewStatus(newMsg);
      }
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
