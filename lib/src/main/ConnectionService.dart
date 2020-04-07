import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/Command.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';
import 'package:redpanda_light_client/src/main/Settings.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/kademlia/KadContent.dart';
import 'package:redpanda_light_client/src/main/store/moor_database.dart';
import 'package:redpanda_light_client/src/redpanda_isolate.dart';
import 'package:sentry/sentry.dart';

import 'NodeId.dart';

class ConnectionService {
  static final log = Logger('RedPandaLightClient');
  static final SentryClient sentry =
      new SentryClient(dsn: "https://5ab6bb5e18a84fc1934b438139cc13d1@sentry.io/3871436");

  /**
   * The local settings will be obtained from db in the start method.
   * It will be periodically update by the maintain method.
   */
  static LocalSetting localSetting;

  static String pathToDatabase;

  /**
   * We have to maintain a list to map KademliaIds to the internal channel id of our database such that we can
   * map KademliaIds to our channel if we get an answer from nodes.
   */
  static HashMap<KademliaId, int> currentKademliaIdtoChannelId = HashMap<KademliaId, int>();

  static NodeId nodeId;
  static KademliaId kademliaId;
  static int myUserId;
  static AppDatabase _appDatabase;
  Timer loopTimer;
  static int myPort;

  ConnectionService(String pathToDatabase, int mPort) {
    ConnectionService.pathToDatabase = pathToDatabase;
    myPort = mPort;
  }

  static AppDatabase get appDatabase => _appDatabase;

  static set appDatabase(AppDatabase value) {
    _appDatabase = value;
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
    if (PeerList.size() < 3) {
      reseed();
    }

    List<Peer> toRemove = [];

    log.finest('loop through peers');

    for (Peer peer in PeerList.getList()) {
      log.finest('Peer: ${peer.getKademliaId()} retries: ${peer.restries} ip: ${peer.ip}');

      if (peer.restries > 10) {
        toRemove.add(peer);
        if (peer.getKademliaId() != null) {
          await ConnectionService.appDatabase.dBPeersDao.removePeerByKademliaId(peer.getKademliaId());
        }
        continue;
      }

      if (peer.connecting || peer.connected) {
        if (new DateTime.now().millisecondsSinceEpoch - peer.lastActionOnConnection > 1000 * 30) {
          peer.disconnect("timeout");
        }

        if (peer.connected && peer.isEncryptionActive) {
          ByteBuffer byteBuffer = new ByteBuffer(1);
          byteBuffer.writeByte(Command.PING);

          byteBuffer.flip();

          runZoned<Future<void>>(() async {
            await peer.sendEncrypt(byteBuffer);
          }, onError: (error, stackTrace) {
            log.fine("failed to ping peer... captured for peer: " + peer.ip);
            peer.disconnect("failed to ping peer");
//            print("failed to ping peer... captured for peer: " + peer.ip + " : " + error.toString());
//            print(stackTrace);
//            ConnectionService.sentry.captureException(exception: error, stackTrace: stackTrace);
          });
//          print('pinged peer...');
        }

        continue;
      }

      runZoned<Future<void>>(() async {
        await connectTo(peer);
      }, onError: (error, stackTrace) {
        peer.disconnect("general error for peer...");
        print("captured for peer: " + peer.ip + " : " + error.toString());
        print(stackTrace);
//        ConnectionService.sentry.captureException(exception: error, stackTrace: stackTrace);
      });

      //only connect to one node each time
//      break;
    }

    for (Peer peer in toRemove) {
      await PeerList.remove(peer);
    }

    refreshStatus();
  }

  /**
   * Method to start the ConnectionService.
   */
  Future<void> start({bool debugOnly = false}) async {
    /**
     * Setup database and LocalSettings...
     */

    _appDatabase = new AppDatabase();

    await setupLocalSettings();

    var list = await _appDatabase.getAllChannels();

    if (list.isEmpty) {
      log.finest('test insert first channel');
      await _appDatabase.createNewChannel("First test channel");
    }

    log.fine('My NodeId: ' + kademliaId.toString());

    if (debugOnly) {
      return;
    }

    for (DBPeer dbp in await appDatabase.dBPeersDao.getAllPeers()) {
      PeerList.add(Peer.fromDBPeer(dbp));
      if (dbp.publicKey != null) {
        print("added peer from db: " +
            dbp.ip +
            " " +
            NodeId.importPublic(dbp.publicKey).toString() +
            " " +
            KademliaId.fromBytes(dbp.kademliaId).toString());
      } else {
        print("added peer from db: " + dbp.ip + " null" + " " + KademliaId.fromBytes(dbp.kademliaId).toString());
      }
    }

    /**
     * We run loop immediately and every 5 seconds, this method will check for
     * timed out peers and establish connections.
     */
    await loop();
    new Timer(Duration(seconds: 1), () => {loop()});
    new Timer(Duration(seconds: 2), () => {loop()});
    new Timer(Duration(seconds: 3), () => {loop()});

    const timeRepeatConectionMaintain = Duration(seconds: 10);
    loopTimer = new Timer.periodic(timeRepeatConectionMaintain, (Timer t) => {loop()});

    const initFireChannelMaintain = Duration(seconds: 6);
    new Timer(initFireChannelMaintain, () => maintain());

    var seconds = 15 + Utils.random.nextInt(20);
    var timeRepeatChannelMaintain = Duration(seconds: seconds);
    new Timer.periodic(timeRepeatChannelMaintain, (Timer t) => maintain());
  }

  static Future<void> setupLocalSettings() async {
    localSetting = await _appDatabase.getLocalSettings;
    if (localSetting == null) {
      //no settings found

      nodeId = NodeId.withNewKeyPair();
      kademliaId = nodeId.getKademliaId();
      myUserId = Utils.randInteger();

      LocalSettingsCompanion localSettingsCompanion = LocalSettingsCompanion.insert(
          privateKey: nodeId.exportWithPrivate(), kademliaId: kademliaId.bytes, myUserId: myUserId);

      await _appDatabase.save(localSettingsCompanion);
      localSetting = await _appDatabase.getLocalSettings;
      print('new localsettings saved!');
    } else {
      nodeId = NodeId.importWithPrivate(localSetting.privateKey);
      kademliaId = KademliaId.fromBytes(localSetting.kademliaId);
      myUserId = localSetting.myUserId;
      print('Found KademliaId in db: ' + kademliaId.toString());
      assert(nodeId.getKademliaId() == kademliaId);
    }
  }

  Future<void> connectTo(Peer peer) async {
    peer.connecting = true;

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

      log.finer('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}'
          ' ${peer.getKademliaId().toString()}');
      socket.handleError(peer.onError);

      socket.done.then((value) => {peer.onError(value)});

      //      socket.add(utf8.encode("3kgV"));
      //      socket.write(utf8.encode("3kgV"));

      ByteBuffer byteBuffer = new ByteBuffer(4 + 1 + 1 + KademliaId.ID_LENGTH_BYTES + 4);
      byteBuffer.writeList(Utils.MAGIC);
      byteBuffer.writeByte(8); //protocoll version code
      byteBuffer.writeByte(129); //lightClient
      byteBuffer.writeList(kademliaId.bytes);
//      print(byteBuffer.buffer.asUint8List());
      byteBuffer.writeInt(myPort); //port
//      print(byteBuffer.buffer.asUint8List());

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

      await ConnectionService.sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> maintain() async {
    localSetting = await _appDatabase.getLocalSettings;

    List<DBChannel> allChannels = await _appDatabase.getAllChannels();

//    print('channels: ' + allChannels.length.toString());

    int myUserId = localSetting.myUserId;

    int cntUpdatedChannels = 0;

    for (DBChannel dbChannel in allChannels) {
      if (cntUpdatedChannels >= 20) {
        break;
      }

      Channel channel = new Channel(dbChannel);

      Map<String, dynamic> channelData = channel.getChannelData();

//      log.finest("chan object[${dbChannel.id}]: ${dbChannel.channelData}");

      if (channelData == null) {
        continue;
      }

      Map<String, dynamic> userData = null;
      Map<String, dynamic> channelData2 = channelData['userdata'];

      if (channelData2 != null) {
        userData = channelData2[myUserId.toString()];
      } else {
        channelData['userdata'] = {};
      }

      bool updated = false;

      Map<String, dynamic> myUserdata = await generateMyUserData(localSetting, channel.getId());

      if (userData == null) {
//        print('no userdata found from us...');

        channel.setUserData(myUserId, myUserdata);
//        await channel.saveChannelData(_appDatabase);
        updated = true;
      } else {
//        print('found userdata');
        int generated = userData['generated'];
        if (Utils.getCurrentTimeMillis() - generated > 1000 * 5) {
//          print('found userdata is too old...');
          channel.setUserData(myUserId, myUserdata);
//          await channel.saveChannelData(_appDatabase);
          updated = true;
        }
      }

      if (updated) {
        //lets seach the DHT network for fresh channel data

        KademliaId currentKademliaId =
            KadContent.createKademliaId(Utils.getCurrentTimeMillis(), channel.getNodeId().exportPublic());
        currentKademliaIdtoChannelId.putIfAbsent(currentKademliaId, () => channel.getId());

        log.fine("seaching for KadId: " + currentKademliaId.toString());

        ByteBuffer writeBuffer = ByteBuffer(1 + 4 + KademliaId.ID_LENGTH_BYTES);
        writeBuffer.writeByte(Command.KADEMLIA_GET);
        writeBuffer.writeInt(Utils.random.nextInt(6000)); //todo check for ack with this id?
        writeBuffer.writeList(currentKademliaId.bytes);

        await PeerList.sendIntegrated(writeBuffer);

//        print("sleep");
        await new Future.delayed(const Duration(seconds: 6), () => "1");
//        print("sleep end");

        cntUpdatedChannels++;

        Map<String, dynamic> data = channel.getChannelData();
        var watchDBMessageEntries = await ConnectionService.appDatabase.dBMessagesDao.getAllDBMessages(channel.getId());

        var list = [];

        int cnt = 0;
        for (DBMessageWithFriend m in watchDBMessageEntries) {
//          if (!m.fromMe) {
//            continue;
//          }

          cnt++;
          if (cnt > 20) {
            break;
          }
//          print("msg : " + m.message.content);
          var datamsg = {
            "id": m.message.messageId,
            "from": m.message.from,
            "timestamp": m.message.timestamp,
            "content": m.message.content
          };
          list.add(datamsg);
        }
        data['msgs'] = list;

        //lets clean up old userdata
        var userdatas = data['userdata'];
        var toRemove = [];
        for (var ud in userdatas.entries) {
          int timestamp = ud.value['generated'];
          if (Utils.getCurrentTimeMillis() - timestamp > 1000 * 60 * 60 * 24 * 2) {
            print("removing key $ud.key from userdatas...");
            toRemove.add(ud.key);
          }
        }

        for (var remove in toRemove) {
          userdatas.remove(remove);
        }
        //clean finished

//        print("data to write");
//        print(data);

        String channelDataString = jsonEncode(data);
        var channelDataStringBytes = Utils.encodeUTF8(channelDataString);

        KadContent kadContent = new KadContent.createNow(channel.getNodeId().exportPublic(), channelDataStringBytes);

        await kadContent.encryptWith(channel);

        await kadContent.signWith(channel.getNodeId());

        await PeerList.sendIntegrated(kadContent.toCommand());
//        print("send...");
        log.finest("send to integrated.... " + kadContent.getKademliaId().toString());
      }

//      log.finest("");
    }
  }

  static Future<Map<String, dynamic>> generateMyUserData(LocalSetting localSettings, int channelId) async {
    var data = {"nick": localSettings.defaultName, "generated": Utils.getCurrentTimeMillis()};

    return data;
  }
}
