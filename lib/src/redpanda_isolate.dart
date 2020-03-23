import 'dart:collection';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';

final String START = "start";
final String START_DEBUG = "startdebug";
final String CHANNEL_CREATE = "createchannel";
final String CHANNEL_RENAME = "renamechannel";
final String CHANNEL_REMOVE = "removechannel";
final String CHANNELS_WATCH = "watchchannels";
final String CHANNEL_GET_BY_ID = "channelgetbyid";
final String MESSAGES_WATCH = "watchmessages";
final String MESSAGES_SEND = "sendmessages";

final log = Logger('redpanda_isolate');
ConnectionService connectionService;
bool running = false;

List<SendPort> channelWatcher = [];
Map<int, SendPort> messageWatcher = HashMap<int, SendPort>();

//
// The port of the new isolate
// this port will be used to further
// send messages to that isolate
//
SendPort newIsolateSendPort;

//
// Instance of the new Isolate
//
Isolate newIsolate;

//
// Method that launches a new isolate
// and proceeds with the initial
// hand-shaking
//
void setupAndStartIsolate() async {
  //
  // Local and temporary ReceivePort to retrieve
  // the new isolate's SendPort
  //
  ReceivePort receivePort = ReceivePort();

  //
  // Instantiate the new isolate
  //
  newIsolate = await Isolate.spawn(
    callbackFunction,
    receivePort.sendPort,
  );

  //
  // Retrieve the port to be used for further
  // communication
  //
  newIsolateSendPort = await receivePort.first;
}

//
// The entry point of the new isolate
//
//
void callbackFunction(SendPort callerSendPort) {
//
// Instantiate a SendPort to receive message
// from the caller
//
  ReceivePort newIsolateReceivePort = ReceivePort();

//
// Provide the caller with the reference of THIS isolate's SendPort
//
  callerSendPort.send(newIsolateReceivePort.sendPort);

//
// Isolate main routine that listens to incoming messages,
// processes it and provides an answer
//
  newIsolateReceivePort.listen((dynamic message) {
    if (message is CrossIsolatesMessage) {
      CrossIsolatesMessage incomingMessage = message as CrossIsolatesMessage;
      parseIsolateCommands(incomingMessage);
    }
  });
}

void parseIsolateCommands(CrossIsolatesMessage incomingMessage) async {
  String command = incomingMessage.message;
  dynamic data = incomingMessage.data;

  print("isolate cmd: " + command + " data: " + data.toString());

  //
  // Process the message
  //
  if (command == START) {
    String dataFolderPath = data['dataFolderPath'];
    int myPort = data['myPort'];

    Logger.root.level = Level.INFO; // defaults to Level.INFO
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
    incomingMessage.sender.send(null);
  } else if (command == START_DEBUG) {
    String dataFolderPath = data['dataFolderPath'];
    int myPort = data['myPort'];

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
    await connectionService.start(debugOnly: true);
    incomingMessage.sender.send(null);
  }
  // Channel operations
  else if (command == CHANNEL_CREATE) {
    String name = data['name'];
    var i = await ConnectionService.appDatabase.createNewChannel(name);
    incomingMessage.sender.send(i);
    refreshChannelsWatching();
  } else if (command == CHANNEL_RENAME) {
    int channelId = data['channelId'];
    String name = data['newName'];
    var i = await ConnectionService.appDatabase.renameChannel(channelId, name);
    incomingMessage.sender.send(i);
    refreshChannelsWatching();
  } else if (command == CHANNEL_REMOVE) {
    int channelId = data['channelId'];
    var i = await ConnectionService.appDatabase.removeChannel(channelId);
    incomingMessage.sender.send(i);
    refreshChannelsWatching();
  } else if (command == CHANNEL_GET_BY_ID) {
    int channelId = data['channelId'];
    var i = await ConnectionService.appDatabase.getChannelById(channelId);
    incomingMessage.sender.send(i);
  } else if (command == CHANNELS_WATCH) {
    channelWatcher.add(incomingMessage.sender);

    refreshChannelsWatching();

//    var i = ConnectionService.appDatabase.watchDBChannelEntries();
//    await for (List<DBChannel> c in i) {
//      print("asddwdwd: " + c.length.toString());
//      incomingMessage.sender.send(c);
//    }
  }
  // all stuff related to messages
  else if (command == MESSAGES_WATCH) {
    print("messages watched");
    int channelId = data['channelId'];
    //todo add by channel id...
    messageWatcher.update(channelId, (value) => incomingMessage.sender, ifAbsent: () => incomingMessage.sender);

    print("messages watched");

    //getcomplete message list
    var allmsgs = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channelId);
//    print("all msgs: " + allmsgs.toString());
    incomingMessage.sender.send(allmsgs);
  } else if (command == MESSAGES_SEND) {
    int channelId = data['channelId'];
    String text = data['text'];
    var newMessageId = await ConnectionService.appDatabase.dBMessagesDao.writeMessage(channelId, text);
    incomingMessage.sender.send(newMessageId);
    refreshMessagessWatching(channelId);
  }

  //
  else if (command == "unknown") {
    String newMessage = "asdg " + incomingMessage.message;
    incomingMessage.sender.send(newMessage);
  }
}

refreshMessagessWatching(int channelId) async {
  print('refreshing messages...');

  var mw = messageWatcher[channelId];
  if (mw == null) {
    return;
  }

  var allmsgs = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channelId);
//  print("all msgs: " + allmsgs.toString());
  mw.send(allmsgs);
}

refreshChannelsWatching() async {
  print('refreshing channels...');
  var allChannels = await ConnectionService.appDatabase.getAllChannels();

  for (SendPort sp in channelWatcher) {
    sp.send(allChannels);
  }
}

//
// Helper class
//
class CrossIsolatesMessage<T> {
  final SendPort sender;
  final T message;
  final dynamic data;

  CrossIsolatesMessage({
    this.sender,
    this.message,
    this.data,
  });
}

String formatToMinLen(String s, int len) {
  int toAdd = len - s.length;
  if (toAdd < 1) {
    return s;
  }

  for (int i = 0; i < toAdd; i++) {
    s += " ";
  }
  return s;
}
