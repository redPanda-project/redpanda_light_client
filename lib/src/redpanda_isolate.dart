// @dart=2.9
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:logging/logging.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/IsolateCommand.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';

dynamic logLevel = Level.INFO; // defaults to Level.INFO

Stopwatch stopWatch = Stopwatch()..start();

final log = Logger('redpanda_isolate');
ConnectionService connectionService;
bool running = false;
int lastPinged = Utils.getCurrentTimeMillis();

List<SendPort> channelWatcher = [];
Map<int, SendPort> messageWatcher = HashMap<int, SendPort>();
SendPort onNewMessageLisener;
SendPort onNewStatusLisener;

Isolate newIsolate;

Stream<String> readLine() => stdin.transform(utf8.decoder).transform(const LineSplitter());

void processLine(String line) async {
  print(line);

  if (line == "") {
    print("Node: ${ConnectionService.kademliaId} myUserId: ${ConnectionService.myUserId}");
    PeerList.getList().forEach((Peer p) {
      print(
          "${formatToMinLen("${p.ip}:${p.port}", 25)}  ${formatToMinLen("${p.getKademliaId()}", 30)}  ${formatToMinLen("${p.connected}", 6)} ${formatToMinLen("${p.restries}", 3)}");
    });
    print("");
  } else if (line == "c") {
    print("create new channel with name: ");
    var name = stdin.readLineSync();
    print("name: $name");
    if (name.isNotEmpty) {
      var id = await ConnectionService.appDatabase.createNewChannel(name);
      print("created new channel: $name and id: $id");
    }
  } else if (line == "e") {
    await shutdown();
    exit(0);
  }
}

Stream<String> read() async* {
  await for (var codeUnits in stdin) {
    var line = Utf8Codec().decode(codeUnits);
    yield line.substring(0, line.length - 1);
  }
}

Future<void> readLines() async {
  var readStream = read().asBroadcastStream();

  new Timer(Duration(seconds: 5), () => Logger.root.level = logLevel);
  Logger.root.level = Level.OFF;
  Timer logNormalTimer;

  while (true) {
    var line = await readStream.first;

    if (logNormalTimer != null) {
      logNormalTimer.cancel();
    }
    logNormalTimer = new Timer(Duration(seconds: 30), () => Logger.root.level = logLevel);
    Logger.root.level = Level.OFF;

    if (line == "") {
      print("");
      print("");
      print("Node: ${ConnectionService.kademliaId} myUserId: ${ConnectionService.myUserId}");
      PeerList.getList().forEach((Peer p) {
        print(
            "${formatToMinLen("${p.ip}:${p.port}", 25)}  ${formatToMinLen("${p.getKademliaId()}", 30)}  ${formatToMinLen("${p.connected}", 6)} ${formatToMinLen("${p.restries}", 3)}");
      });
      print("");
      var allChannels = await ConnectionService.appDatabase.getAllChannels();
      for (var c in allChannels) {
        var channel = new Channel(c);
        print(
            "Channel: ${formatToMinLen("${channel.getId()}", 4)}    ${formatToMinLen(channel.name, 10)}   ${formatToMinLen(channel.shareString(), 30)}");
      }
      print("");
      print("");
    } else if (line == "c") {
      print("create new channel with name: ");
      var name = await readStream.first;
      print("name: $name");
      if (name.isNotEmpty) {
        var id = await ConnectionService.appDatabase.createNewChannel(name);
        print("created new channel: $name and id: $id");
      }
    } else if (line == "i") {
      print("import new channel with name:");
      var name = await readStream.first;
      if (name.isNotEmpty) {
        print("name: $name, insert shared channel string: ");
        var string = await readStream.first;
        if (string.isNotEmpty) {
          Channel.insertSharedChannel(string, name);
        }
      }
    } else if (line == "n") {
      print("channel to write new messages, exit writing with a empty line:");
      var channelIdString = await readStream.first;
      if (channelIdString.isNotEmpty) {
        var channelId = int.parse(channelIdString);
        while (true) {
          var text = await readStream.first;
          if (text.isNotEmpty) {
            ConnectionService.appDatabase.dBMessagesDao.writeMessage(channelId, text);
          } else {
            break;
          }
        }
      }
    } else if (line == "nick") {
      print('set nick');
      var nick = await readStream.first;
      ConnectionService.appDatabase.setNickname(nick);
    } else if (line == "r") {
      print("remove channel by id:");
      var id = await readStream.first;
      if (id.isNotEmpty) {
        var parse = int.parse(id);
        ConnectionService.appDatabase.removeChannel(parse);
        print("remove channel: " + parse.toString());
      }
    } else if (line == "e") {
      await shutdown();
      exit(0);
    }
  }
}

Future<void> setupAndStartIsolate() async {
  ReceivePort receivePort = ReceivePort();

  newIsolate = await Isolate.spawn(
    callbackFunction,
    receivePort.sendPort,
  );

  ReceivePort errorPort = ReceivePort();

  newIsolate.addErrorListener(errorPort.sendPort);
  errorPort.listen((listMessage) {
    String errorDescription = listMessage[0];
    String stackDescription = listMessage[1];
    ConnectionService.sentry.captureException(errorDescription, stackTrace: stackDescription);
    print(errorDescription);
    print(stackDescription);
  });

  RedPandaLightClient.newIsolateSendPort = await receivePort.first;
}

void callbackFunction(SendPort callerSendPort) {
  ReceivePort newIsolateReceivePort = ReceivePort();
  callerSendPort.send(newIsolateReceivePort.sendPort);

  newIsolateReceivePort.listen((dynamic message) {
    SendPort sendPort = message["sender"];
    String command = message["command"];
    dynamic data = message["data"];

    parseIsolateCommands(sendPort, command, data);
  });
}

Future<void> shutdown() async {
  await ConnectionService.appDatabase.close();
  connectionService.loopTimer.cancel();
  for (Peer peer in PeerList.getList()) {
    peer.disconnect("shutdown");
  }
  Isolate.current.kill();
  return;
}

void parseIsolateCommands(SendPort answerSendPort, String command, dynamic data) async {
  print("isolate cmd: " + command + " data: " + data.toString() + " after boot: ${stopWatch.elapsed}");

  if (command == IsolateCommand.PING.toString()) {
    lastPinged = Utils.getCurrentTimeMillis();
  } else if (command == IsolateCommand.SHUTDOWN.toString()) {
    log.info("RedPandaLightClient shutting down...");
    await shutdown();
    answerSendPort.send(null);
  } else if (command == IsolateCommand.START.toString()) {
    if (running) {
      log.info("RedPandaLightClient already running skipping new init...");
      answerSendPort.send(null);
      return;
    }
    running = true;

    //listen for console if running on Windows or Linux
    if (Platform.isWindows || Platform.isLinux) {
      /**
       * start listing to console from Isolate such that we can use all objects on the isolate side
       */
//      readLine().listen(processLine);
      readLines();
    }
    String dataFolderPath = data['dataFolderPath'];
    int myPort = data['myPort'];

    Logger.root.level = logLevel; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${formatToMinLen(record.loggerName, 30)}: ${formatToMinLen(record.time.toString(), 26)}:    ${record.message}');
    });

    connectionService = ConnectionService(dataFolderPath, myPort);
    var allChannels = await connectionService.start();

    answerSendPort.send(allChannels);
    print('send first channel list after boot: ${stopWatch.elapsed}');

    channelWatcher.clear();
    channelWatcher.add(answerSendPort);
  } else if (command == IsolateCommand.START_DEBUG.toString()) {
    String dataFolderPath = data['dataFolderPath'];
    int myPort = data['myPort'];

    if (running) {
      log.info("RedPandaLightClient already running skipping new init...");
      return;
    }
    running = true;

    Logger.root.level = logLevel; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${formatToMinLen(record.loggerName, 30)}: ${formatToMinLen(record.time.toString(), 26)}:    ${record.message}');
    });

    connectionService = ConnectionService(dataFolderPath, myPort);
    await connectionService.start(debugOnly: true);
    answerSendPort.send(null);
  }
  // Channel operations
  else if (command == IsolateCommand.CHANNEL_CREATE.toString()) {
    String name = data['name'];
    var i = await ConnectionService.appDatabase.createNewChannel(name);
    answerSendPort.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_FROM_DATA.toString()) {
    String sharedData = data['data'];
    String name = data['name'];
    var i = await Channel.insertSharedChannel(sharedData, name);
    answerSendPort.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_RENAME.toString()) {
    int channelId = data['channelId'];
    String name = data['newName'];
    var i = await ConnectionService.appDatabase.renameChannel(channelId, name);
    answerSendPort.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_REMOVE.toString()) {
    int channelId = data['channelId'];
    var i = await ConnectionService.appDatabase.removeChannel(channelId);
    answerSendPort.send(i);
    refreshChannelsWatching();
  } else if (command == IsolateCommand.CHANNEL_GET_BY_ID.toString()) {
    int channelId = data['channelId'];
    var i = await ConnectionService.appDatabase.getChannelById(channelId);
    answerSendPort.send(i);
  } else if (command == IsolateCommand.CHANNELS_WATCH.toString()) {
    //currently only one listener ist supported....
    channelWatcher.clear();
    channelWatcher.add(answerSendPort);

    refreshChannelsWatching();
  }
  // all stuff related to messages
  else if (command == IsolateCommand.MESSAGES_WATCH.toString()) {
    print("messages watched");
    int channelId = data['channelId'];
    //todo add by channel id...
    messageWatcher.update(channelId, (value) => answerSendPort, ifAbsent: () => answerSendPort);

    print("messages watched");

    var allmsgs = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channelId);
    answerSendPort.send(allmsgs);
  } else if (command == IsolateCommand.MESSAGES_SEND.toString()) {
    int channelId = data['channelId'];
    String text = data['text'];
    var newMessageId = await ConnectionService.appDatabase.dBMessagesDao.writeMessage(channelId, text);
    answerSendPort.send(newMessageId);
    refreshMessagesWatching(channelId);
  } else if (command == IsolateCommand.MESSAGES_GET_RECENT.toString()) {
    int channelId = data['channelId'];
    String text = data['text'];
    var allMsgs = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channelId);
    answerSendPort.send(allMsgs);
  } else if (command == IsolateCommand.MESSAGES_LISTEN_NEW.toString()) {
    onNewMessageLisener = answerSendPort;
  } else if (command == IsolateCommand.STATUS_LISTEN.toString()) {
    onNewStatusLisener = answerSendPort;
  }

  //
  else if (command == IsolateCommand.SET_NAME.toString()) {
    String name = data['name'];
    var i = await ConnectionService.appDatabase.setNickname(name);
    /**
     * lets update the name in our local database file
     */
    ConnectionService.localSetting = ConnectionService.localSetting.copyWith(defaultName: Value(name));
    answerSendPort.send(i);
  } else if (command == IsolateCommand.INSERT_FCM_TOKEN.toString()) {
    String token = data['token'];
    var i = await ConnectionService.appDatabase.insertFCMToken(token);
    answerSendPort.send(i);
  }
  //
  else if (command == "unknown") {
    String newMessage = "asdg " + command;
    answerSendPort.send(newMessage);
  }
}

/**
 * If now messageId is provided we assume that this message was send from us and we do not have to generate a new
 * notification.
 */
refreshMessagesWatching(int channelId, {int messageId = -1, String channelName}) async {
  print('refreshing messages...');

  if (messageId != -1 && onNewMessageLisener != null) {
    onNewMessageLisener.send(//
        {
      'name': channelName, //
      'data': await ConnectionService.appDatabase.dBMessagesDao.getMessageById(messageId)
    } //
        );
  }

  var mw = messageWatcher[channelId];
  if (mw == null) {
    return;
  }

  var allmsgs = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channelId);
  mw.send(allmsgs);
}

refreshChannelsWatching() async {
  print('refreshing channels...');
  var allChannels = await ConnectionService.appDatabase.getAllChannels();

  for (SendPort sp in channelWatcher) {
    sp.send(allChannels);
  }
}

Future<void> refreshStatus() async {
  log.finest('refreshing status...');

  if (onNewStatusLisener != null) {
    var defaultName = ConnectionService.localSetting.defaultName;

    if (defaultName == null || defaultName.isEmpty) {
      onNewStatusLisener.send("Please set your name in the menu.");
      return;
    }

    int active = 0;
    PeerList.getList().forEach((Peer p) {
      if (p.connected) {
        active++;
      }
    });

    onNewStatusLisener.send("Connected: $active/${PeerList.getList().length}");
  }
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
