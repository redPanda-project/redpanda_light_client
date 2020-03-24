import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/IsolateCommand.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';

dynamic logLevel = Level.INFO; // defaults to Level.INFO

//final String START = "start";
//final String START_DEBUG = "startdebug";
//final String CHANNEL_CREATE = "createchannel";
//final String CHANNEL_FROM_DATA = "channelfromdata";
//final String CHANNEL_RENAME = "renamechannel";
//final String CHANNEL_REMOVE = "removechannel";
//final String CHANNELS_WATCH = "watchchannels";
//final String CHANNEL_GET_BY_ID = "channelgetbyid";
//final String MESSAGES_WATCH = "watchmessages";
//final String MESSAGES_GET_RECENT = "getrecentmsgs";
//final String MESSAGES_SEND = "sendmessages";
//final String MESSAGES_LISTEN_NEW = "msgslistennew";

final log = Logger('redpanda_isolate');
ConnectionService connectionService;
bool running = false;
int lastPinged = Utils.getCurrentTimeMillis();

List<SendPort> channelWatcher = [];
Map<int, SendPort> messageWatcher = HashMap<int, SendPort>();
SendPort onNewMessageLisener;
SendPort onNewStatusLisener;

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

  new Timer.periodic(Duration(seconds: 1), (t) {
    if (Utils.getCurrentTimeMillis() - lastPinged > 10000) {
      print("isolate didnt receive ping in time, shutdown isolate");
      shutdown();
    }
  });
}

void shutdown() async {
  await ConnectionService.appDatabase.close();
  await connectionService.loopTimer.cancel();
  for (Peer peer in PeerList.getList()) {
    await peer.disconnect("shutdown");
  }
  Isolate.current.kill();
}

void parseIsolateCommands(CrossIsolatesMessage incomingMessage) async {
  IsolateCommand command = incomingMessage.message;
  dynamic data = incomingMessage.data;

//  print("isolate cmd: " + command.toString() + " data: " + data.toString());

  //
  // Process the message
  //
  if (command == IsolateCommand.PING) {
    lastPinged = Utils.getCurrentTimeMillis();
  } else if (command == IsolateCommand.SHUTDOWN) {
    log.info("RedPandaLightClient shutting down...");
//    running = false;
    await shutdown();
  } else if (command == IsolateCommand.START) {
    String dataFolderPath = data['dataFolderPath'];
    int myPort = data['myPort'];

    Logger.root.level = logLevel; // defaults to Level.INFO
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
  } else if (command == IsolateCommand.START_DEBUG) {
    String dataFolderPath = data['dataFolderPath'];
    int myPort = data['myPort'];

    Logger.root.level = logLevel; // defaults to Level.INFO
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
  else if (command == IsolateCommand.CHANNEL_CREATE) {
    String name = data['name'];
    var i = await ConnectionService.appDatabase.createNewChannel(name);
    incomingMessage.sender.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_FROM_DATA) {
    String name = data['name'];
    Uint8List sharedSecret = data['sharedSecret'];
    Uint8List privateSigningKey = data['privateSigningKey'];
    var i = await ConnectionService.appDatabase.createChannelFromData(name, sharedSecret, privateSigningKey);
    incomingMessage.sender.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_RENAME) {
    int channelId = data['channelId'];
    String name = data['newName'];
    var i = await ConnectionService.appDatabase.renameChannel(channelId, name);
    incomingMessage.sender.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_REMOVE) {
    int channelId = data['channelId'];
    var i = await ConnectionService.appDatabase.removeChannel(channelId);
    incomingMessage.sender.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_GET_BY_ID) {
    int channelId = data['channelId'];
    var i = await ConnectionService.appDatabase.getChannelById(channelId);
    incomingMessage.sender.send(i);
  } else if (command == IsolateCommand.CHANNELS_WATCH) {
    channelWatcher.add(incomingMessage.sender);

    refreshChannelsWatching();

//    var i = ConnectionService.appDatabase.watchDBChannelEntries();
//    await for (List<DBChannel> c in i) {
//      print("asddwdwd: " + c.length.toString());
//      incomingMessage.sender.send(c);
//    }
  }
  // all stuff related to messages
  else if (command == IsolateCommand.MESSAGES_WATCH) {
    print("messages watched");
    int channelId = data['channelId'];
    //todo add by channel id...
    messageWatcher.update(channelId, (value) => incomingMessage.sender, ifAbsent: () => incomingMessage.sender);

    print("messages watched");

    //getcomplete message list
    var allmsgs = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channelId);
//    print("all msgs: " + allmsgs.toString());
    incomingMessage.sender.send(allmsgs);
  } else if (command == IsolateCommand.MESSAGES_SEND) {
    int channelId = data['channelId'];
    String text = data['text'];
    var newMessageId = await ConnectionService.appDatabase.dBMessagesDao.writeMessage(channelId, text);
    incomingMessage.sender.send(newMessageId);
    refreshMessagesWatching(channelId);
  } else if (command == IsolateCommand.MESSAGES_GET_RECENT) {
    int channelId = data['channelId'];
    String text = data['text'];
    var allMsgs = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channelId);
    incomingMessage.sender.send(allMsgs);
  } else if (command == IsolateCommand.MESSAGES_LISTEN_NEW) {
    onNewMessageLisener = incomingMessage.sender;
  } else if (command == IsolateCommand.STATUS_LISTEN) {
    onNewStatusLisener = incomingMessage.sender;
  }

  //
  else if (command == "unknown") {
    String newMessage = "asdg " + incomingMessage.message;
    incomingMessage.sender.send(newMessage);
  }
}

/**
 * If now messageId is provided we assume that this message was send from us and we do not have to generate a new
 * notification.
 */
refreshMessagesWatching(int channelId, {int messageId = -1}) async {
  print('refreshing messages...');

  if (messageId != -1 && onNewMessageLisener != null) {
    onNewMessageLisener.send(await ConnectionService.appDatabase.dBMessagesDao.getMessageById(messageId));
  }

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

refreshStatus() async {
  print('refreshing status...');

  if (onNewStatusLisener != null) {
    int active = 0;
    PeerList.getList().forEach((Peer p) {
      if (p.connected) {
        active++;
      }
    });

    onNewStatusLisener.send("Connected: ${active}/${PeerList.getList().length}");
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
