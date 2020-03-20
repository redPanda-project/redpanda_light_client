import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:redpanda_light_client/src/isolate_runner.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';

final String START = "start";

final log = Logger('redpanda_isolate');
ConnectionService connectionService;
bool running = false;

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
      String command = incomingMessage.message;
      dynamic data = incomingMessage.data;

      print(data);

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
         connectionService.start();
      } else if (command == "unknown") {
        String newMessage = "complemented string " + incomingMessage.message;

        //
        // Sends the outcome of the processing
        //
        incomingMessage.sender.send(newMessage);
      }
    }
  });
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
