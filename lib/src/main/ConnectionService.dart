import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Command.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';
import 'package:redpanda_light_client/src/main/Settings.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/store/moor_database.dart';
import 'package:sentry/sentry.dart';

import 'NodeId.dart';

class ConnectionService {
  static final SentryClient sentry =
      new SentryClient(dsn: "https://5ab6bb5e18a84fc1934b438139cc13d1@sentry.io/3871436");

  static LocalSetting localSetting;

  static String pathToDatabase;

  static NodeId nodeId;
  static KademliaId kademliaId;
  static AppDatabase appDatabase;
  Timer loopTimer;
  static int myPort;

  ConnectionService(String pathToDatabase, int mPort) {
    ConnectionService.pathToDatabase = pathToDatabase;
    myPort = mPort;
  }

  Future<void> loop() async {
    //todo we have to use the zone around each peer and not for the entire loop
    runZoned<Future<void>>(() async {
      loop2();
    }, onError: (error, stackTrace) {
      print(error);
      print(stackTrace);
      ConnectionService.sentry.captureException(exception: error, stackTrace: stackTrace);
    });
  }

  Future<void> loop2() async {
    if (PeerList.length() < 3) {
      reseed();
    }

    List<Peer> toRemove = [];

    for (Peer peer in PeerList.getList()) {
      print('Peer: ${peer.getKademliaId()} retries: ${peer.restries} ');

      if (peer.restries > 10) {
        toRemove.add(peer);
        continue;
      }

      if (peer.connecting || peer.connected) {
        if (new DateTime.now().millisecondsSinceEpoch - peer.lastActionOnConnection > 1000 * 15) {
          peer.disconnect();

          for (Function setState in Utils.states) {
            setState(() {
              // This call to setState tells the Flutter framework that something has
              // changed in this State, which causes it to rerun the build method below
              // so that the display can reflect the updated values. If we changed
              // _counter without calling setState(), then the build method would not be
              // called again, and so nothing would appear to happen.
              peer.connecting = false;
              peer.connected = false;
            });
          }
        }

        if (peer.connected && peer.isEncryptionActive) {
          ByteBuffer byteBuffer = new ByteBuffer(1);
          byteBuffer.writeByte(Command.PING);

          byteBuffer.flip();

          await peer.sendEncrypt(byteBuffer);
//          print('pinged peer...');
        }

        continue;
      }

      connectTo(peer);
    }

    for (Peer peer in toRemove) {
      PeerList.remove(peer);
    }
  }

  /**
   * Method to start the ConnectionService.
   */
  Future<void> start() async {
    /**
     * Setup database and LocalSettings...
     */

    appDatabase = new AppDatabase();

    localSetting = await appDatabase.getLocalSettings;
    if (localSetting == null) {
      //no settings found

      nodeId = NodeId.withNewKeyPair();
      kademliaId = nodeId.getKademliaId();

      LocalSettingsCompanion localSettingsCompanion =
          LocalSettingsCompanion.insert(privateKey: nodeId.exportWithPrivate(), kademliaId: kademliaId.bytes);

      await appDatabase.save(localSettingsCompanion);
      print('new localsettings saved!');
    } else {
      nodeId = NodeId.importWithPrivate(localSetting.privateKey);
      kademliaId = KademliaId.fromBytes(localSetting.kademliaId);
      print('Found KademliaId in db: ' + kademliaId.toString());
      assert(nodeId.getKademliaId() == kademliaId);
    }

    print('test insert new channel');
    ChannelsCompanion channelsCompanion =
        ChannelsCompanion.insert(name: "Title1", lastMessage_text: "last msg", lastMessage_user: "james");
    await appDatabase.insertChannel(channelsCompanion);

    print('My NodeId: ' + kademliaId.toString());

    /**
     * We run loop immediately and every 5 seconds, this method will check for
     * timed out peers and establish connections.
     */
    loop();
    const oneSec = Duration(seconds: 5);
    loopTimer = new Timer.periodic(oneSec, (Timer t) => {loop()});
  }

  Future<void> connectTo(Peer peer) async {
    for (Function setState in Utils.states) {
      setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        peer.connecting = true;
      });
    }

    peer.lastActionOnConnection = new DateTime.now().millisecondsSinceEpoch;
    peer.restries++;

    Socket.connect(peer.ip, peer.port).catchError(peer.onError).then((socket) {
      if (socket == null) {
        peer.connecting = false;
//        print('error connecting...');
        return;
      }

      peer.reset();

      peer.socket = socket;

      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      socket.handleError(peer.onError);

      socket.done.then((value) => {peer.onError(value)});

      //      socket.add(utf8.encode("3kgV"));
      //      socket.write(utf8.encode("3kgV"));

      ByteBuffer byteBuffer = new ByteBuffer(4 + 1 + 1 + KademliaId.ID_LENGTH_BYTES + 4);
      byteBuffer.writeList(Utils.MAGIC);
      byteBuffer.writeByte(8); //protocoll version code
      byteBuffer.writeByte(129); //lightClient
      byteBuffer.writeList(kademliaId.bytes);
      print(byteBuffer.buffer.asUint8List());
      byteBuffer.writeInt(myPort); //port
      print(byteBuffer.buffer.asUint8List());

      socket.add(byteBuffer.buffer.asInt8List());

      //      socket.writeCharCode(8);
//      socket.add(nodeId.bytes);
      //      socket.add(59558);
      //      socket.flush();
      socket.listen(peer.ondata);

      //      socket.destroy();
    });
  }

//  void dataHandler(data) {
//    print(new String.fromCharCodes(data).trim());
//  }
//
//  void errorHandler(error, StackTrace trace) {
//    print(error);
//  }
//
//  void doneHandler() {
//    socket.destroy();
//  }

  void reseed() {
//    print('reseed...');
    for (String str in Settings.seedNodeList) {
      List<String> split = str.split(":");
      String ip = split[0];
      int port = int.tryParse(split[1]);
      if (port == null) {
        return;
      }
      Peer peer = new Peer(ip, port);
      PeerList.add(peer);
    }
  }

  // Methods for Sentry
  static bool get isInDebugMode {
    // Assume you're in production mode.
    bool inDebugMode = false;

    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);

    return inDebugMode;
  }

  static Future<void> reportError(dynamic error, dynamic stackTrace) async {
    // Print the exception to the console.
    print('Caught error: $error');
    if (isInDebugMode) {
      // Print the full stacktrace in debug mode.
      print(stackTrace);
      return;
    } else {
      // Send the Exception and Stacktrace to Sentry in Production mode.

      ConnectionService.sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
