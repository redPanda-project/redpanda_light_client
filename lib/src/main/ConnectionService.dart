import 'dart:async';
import 'dart:core';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' hide ByteBuffer;
import 'dart:typed_data';
import 'dart:typed_data' as prefix0;

import 'package:base58check/base58.dart';
import 'package:base58check/base58check.dart';
import 'package:buffer/buffer.dart';
import 'package:byte_array/byte_array.dart';
import 'dart:convert';

import 'package:hex/hex.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Peer.dart';
import 'package:redpanda_light_client/src/main/Settings.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:sentry/sentry.dart';

import 'package:convert/convert.dart';
//import 'package:crypto/crypto.dart';

const String _bitcoinAlphabet =
    "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

class ConnectionService {
  static final SentryClient sentry = new SentryClient(
      dsn: "https://5ab6bb5e18a84fc1934b438139cc13d1@sentry.io/3871436");
  Socket socket;

  static AsymmetricKeyPair nodeKey;
  static KademliaId nodeId;
  List<Peer> peerlist;

  ConnectionService() {
    peerlist = new List();

    final ECKeyGenerator generator = KeyGenerator("EC");
    generator.init(
      ParametersWithRandom(
        ECKeyGeneratorParameters(
          ECDomainParameters("brainpoolp256r1"),
        ),
        getSecureRandom(),
      ),
    );

    nodeKey = generator.generateKeyPair();

    ECPublicKey pubkey = nodeKey.publicKey;
    Uint8List pubkeyBytes = pubkey.Q.getEncoded(false);


    nodeId = KademliaId.fromFirstBytes(pubkeyBytes);


    print('My NodeId: ' + nodeId.toString());
    assert(nodeId.bytes.length == KademliaId.ID_LENGTH_BYTES);

//    print('sha bytes: ' + hex.encode(sha256.convert(pubkey.Q.getEncoded(false)).bytes));


  }

  void loop() {
    if (peerlist.length < 3) {
      reseed();
    }

    for (Peer peer in peerlist) {
      if (peer.connecting || peer.connected) {
        if (new DateTime.now().millisecondsSinceEpoch -
                peer.lastActionOnConnection >
            1000 * 5) {
          if (peer.socket != null) {
            peer.socket.destroy();
          }

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

        continue;
      }

      connectTo(peer);
    }
  }

  /**
   * Method to start the ConnectionService.
   */
  Future<void> start() async {
    /**
     * We run loop immediately and every 5 seconds, this method will check for
     * timed out peers and establish connections.
     */
    loop();
    const oneSec = const Duration(seconds: 5);
    new Timer.periodic(oneSec, (Timer t) => {loop()});
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

    Socket.connect(peer.ip, peer.port).catchError(peer.onError).then((socket) {
      if (socket == null) {
        peer.connecting = false;
//        print('error connecting...');
        return;
      }

      peer.socket = socket;

      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      socket.handleError(peer.onError);

      socket.done.then((value) => {peer.onError(value)});

      //      socket.add(utf8.encode("3kgV"));
      //      socket.write(utf8.encode("3kgV"));

      ByteBuffer byteBuffer =
          new ByteBuffer(4 + 1 + KademliaId.ID_LENGTH_BYTES + 4);
      byteBuffer.writeList('3kgV'.codeUnits);
      byteBuffer.writeByte(8);
      byteBuffer.writeList(nodeId.bytes);
      print(byteBuffer.buffer.asUint8List());
      byteBuffer.writeInt(59558);
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

  void dataHandler(data) {
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
  }

  bool _listsAreEqual(list1, list2) {
    if (list1.length != list2.length) {
      return false;
    }
    var i = -1;
    return list1.every((val) {
      i++;
      if (val is List && list2[i] is List)
        return _listsAreEqual(val, list2[i]);
      else
        return list2[i] == val;
    });
  }

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

      if (!peerlist.contains(peer)) {
//        print('peer not in list add');
        peerlist.add(peer);
      } else {
//        print('peer in list do not add');
      }
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

  SecureRandom getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));
    return secureRandom;
  }
}
