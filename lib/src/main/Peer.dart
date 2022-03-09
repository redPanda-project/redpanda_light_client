import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' hide ByteBuffer;
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:convert/convert.dart';
import 'package:date_format/date_format.dart';
import 'package:logging/logging.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/Command.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/PeerList.dart';
import 'package:redpanda_light_client/src/main/SentryLogger.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/commands/FBPeerList_im.redpanda.commands_generated.dart';
import 'package:redpanda_light_client/src/main/kademlia/KadContent.dart';
import 'package:redpanda_light_client/src/redpanda_isolate.dart';

class Peer {
  static final log = Logger('Peer');
  static final int IVbytelen = 16;
  static final int IVbytelenHalf = 8;

  String _ip;
  int _port;
  int restries = 0;
  int _knownSince;
  int _score;
  int _dbPeerId;

  bool connecting = false;
  bool connected = false;
  bool isEncryptionActive = false;
  int handshakeStatus = 0;
  bool waitingForEncryption = false;
  bool weSendOurRandom = false;

  ByteBuffer decryptBuffer;

  Uint8List randomFromThem;
  Uint8List randomFromUs;

  Uint8List sharedSecretSend;
  Uint8List sharedSecretReceive;

  Uint8List ivSend;
  Uint8List ivReceive;

  CTRStreamCipher ctrStreamCipherSend;
  CTRStreamCipher ctrStreamCipherReceive;

  NodeId _nodeId;
  KademliaId _kademliaId;

  int lastActionOnConnection = 0;

  Socket socket;

  Peer(this._ip, this._port);

  Peer.withNodeId(this._ip, this._port, this._nodeId);

  Peer.fromDBPeer(DBPeer dbp) {
    _dbPeerId = dbp.id;
    _ip = dbp.ip;
    _port = dbp.port;
    if (dbp.kademliaId != null) {
      _kademliaId = KademliaId.fromBytes(dbp.kademliaId);
    }
    if (dbp.publicKey != null) {
      _nodeId = NodeId.importPublic(dbp.publicKey);
    }
    _knownSince = dbp.knownSince;
    _score = dbp.score;
  }

  String get ip => _ip;

  int get port => _port;

  set ip(String value) {
    _ip = value;
  }

  set port(int value) {
    _port = value;
  }

  void updateNodeId(NodeId nodeId) async {
    if (_dbPeerId != null) {
      await ConnectionService.appDatabase.dBPeersDao.updateNodeId(_dbPeerId, nodeId.exportPublic());
    }
    _nodeId = nodeId;
    return;
  }

  KademliaId getKademliaId() {
    if (_kademliaId == null && _nodeId != null) {
      _kademliaId = _nodeId.getKademliaId();
    }
    return _kademliaId;
  }

  void reset() {
    connecting = false;
    connected = false;
    isEncryptionActive = false;
    handshakeStatus = 0;
    waitingForEncryption = false;
    weSendOurRandom = false;

    randomFromThem = null;
    randomFromUs = null;
  }

  void ondata(Uint8List data) async {
//    print(data.toString());

    ByteDataReader byteDataReader = new ByteDataReader();
    byteDataReader.add(data);

    //todo check for is connected...

//    print(Utf8Codec().decode(data.sublist(0, 4)));
//    print(magic);
//    print(data.sublist(0, 4));

//    print(Utf8Codec().decode(data.sublist(0, 4)) == "k3gV");

//    Uint8List readMagic = byteDataReader.read(4);
//    print(readMagic);
//
//    int version = byteDataReader.readUint8();
//    print("version $version");
//
//    if (!_listsAreEqual(magic, readMagic)) {
//      print("wrong magic, disconnect!");
//    }
//
//    Uint8List nonce = byteDataReader.read(20);
//    print("server identity: " + HEX.encode(nonce).toUpperCase());
//    print(Base58Codec(_bitcoinAlphabet).encode(nonce));
//
//
//    print(byteDataReader.remainingLength);
//
//    print(byteDataReader.readUint(2));

    ByteBuffer buffer = ByteBuffer.fromBuffer(data.buffer);

    if (isEncryptionActive && connected) {
      ByteBuffer localDecrypted = decrypt(buffer);

//      print("still to read bytes in buffer: ${decryptBuffer.remaining()}");
//      print('data saved: ' + decryptBuffer.array().toString());

      decryptBuffer.compact();

      while (localDecrypted.remaining() > decryptBuffer.remaining()) {
        print("doubled the size of the read buffer... ${2 * decryptBuffer.length}");
        var newBuffer = ByteBuffer(2 * decryptBuffer.length);

        decryptBuffer.flip();
        newBuffer.writeBytes(decryptBuffer);
        decryptBuffer = newBuffer;
      }

      decryptBuffer.writeBytes(localDecrypted);
      decryptBuffer.flip();

      while (decryptBuffer.remaining() > 0) {
        int posBeforeRead = decryptBuffer.position();
        int readBytes = await readCommand();

        if (readBytes == 0) {
          //we have to wait for more data...
          decryptBuffer.setPosition(posBeforeRead);
          break;
        }

        int newPos = posBeforeRead + readBytes;
        decryptBuffer.setPosition(newPos);
      }
//      print("still to read bytes in buffer2: ${decryptBuffer.remaining()}");

      return;
    }

    if (!isEncryptionActive) {
      if (handshakeStatus == 0) {
        /**
         * The status indicates that no handshake was parsed before for this PeerInHandshake
         */
        bool b = parseHandshake(buffer);

        log.finest('handshake ok: $b');
      } else {
        /**
         * The status indicates that the first handshake was already parsed before for this
         * PeerInHandshake. Here we are providing more data for the other Peer like the public key.
         */
        int command = buffer.readByte();
        if (command == Command.REQUEST_PUBLIC_KEY) {
          /**
           * The other Peer request our public key, lets send our public key!
           */
          sendPublicKeyToPeer();
        } else if (command == Command.SEND_PUBLIC_KEY && handshakeStatus == 1) {
          /**
           * We got the public Peer, lets store it and check that this public key
           * indeed corresponds to the KademliaId.
           */
          List<int> bytesForPublicKey = buffer.readBytes(NodeId.PUBLIC_KEYLEN);

          NodeId peerNodeId = NodeId.importPublic(Uint8List.fromList(bytesForPublicKey));

          log.finer('new nodeid from peer: ' + peerNodeId.toString());

          /**
           * If this peer does not have a KademliaId add it, this should only happen from reseeded peers.
           */

          if (_kademliaId == null) {
            updateNodeId(peerNodeId);
            updateKademliaId(peerNodeId.getKademliaId());
          } else if (_kademliaId != peerNodeId.getKademliaId()) {
            /**
             * We obtained a public key which does not match the KademliaId of this Peer
             * and should cancel that connection here.
             */
            log.warning('wrong public key for node id found, disconnecting...');
            handshakeStatus = 2;
            SentryLogger.log("Error code: g4bdghstg3f4");
            disconnect("wrong public key for node id found, disconnecting...");
          } else {
            /**
             * We obtained the correct public key and can add it to the Peer
             * and lets set that peerInHandshake status to waiting for encryption
             */
            updateNodeId(peerNodeId);
            updateKademliaId(peerNodeId.getKademliaId());
            handshakeStatus = -1;
          }
        } else if (command == Command.ACTIVATE_ENCRYPTION) {
          /**
           * We received the byte to activate the encryption and we are awaiting the encryption activation byte
           */

          //lets read the random bytes from them
          if (buffer.remaining() < IVbytelenHalf) {
            log.warning("not enough bytes for encryption... " + buffer.remaining().toString());
            disconnect("not enough bytes for encryption...");
            return;
          }

          List<int> bytesForPublicKey = buffer.readBytes(IVbytelenHalf);

          randomFromThem = Uint8List.fromList(bytesForPublicKey);
          waitingForEncryption = true;

          log.finest('obtained activate enc cmd and bytes for IV');
        }
      }

      /**
       * Lets check if we are ready to start the encryption for this handshaking peer
       */
      if (handshakeStatus == -1 && !weSendOurRandom) {
        //activate enc todo change to schema from java
        ByteBuffer byteBuffer = new ByteBuffer(1 + IVbytelenHalf);
        byteBuffer.writeByte(Command.ACTIVATE_ENCRYPTION);
        byteBuffer.writeList(getRandomFromUs());
        socket.add(byteBuffer.array());

        log.finer("written bytes for ACTIVATE_ENCRYPTION");

        weSendOurRandom = true;
      }

      if (handshakeStatus == -1 && waitingForEncryption && hasPublicKey()) {
        waitingForEncryption = false;

        log.finest("lets generate the shared secret");

        calculateSharedSecret();

        /**
         * Shared Secret and IV calculated via ECDH and random bytes,
         * lets activate the encryption
         */

        activateEncryption();

        /**
         * lets send the first ping
         */

        ByteBuffer byteBuffer = new ByteBuffer(1);
        byteBuffer.writeByte(Command.PING);

        byteBuffer.flip();

        sendEncrypt(byteBuffer);
      }
    } else {
      /**
       * The encryption is active in this section, lets check that first ping
       */
      log.finer("received first encrypted command...");

      ByteBuffer firstEncByte = decrypt(buffer);

      int decryptedCommand = firstEncByte.readByte();

      log.finer("received first encrypted command: " + decryptedCommand.toString());

      if (decryptedCommand == Command.PING) {
        log.finer("received first ping...");

        /**
         * We can now safely transfer the open connection from the peerInHandshake to the
         * actual peer
         */

        decryptBuffer = ByteBuffer(200);
        decryptBuffer.flip();
        //todo setup connection
        connected = true;
        restries = 0;

        //lets request some peers

        ByteBuffer byteBuffer = new ByteBuffer(1);
        byteBuffer.writeByte(Command.REQUEST_PEERLIST);

        byteBuffer.flip();

        sendEncrypt(byteBuffer);
      }
    }

//    if (!isEncryptionActive) {
//    if (handshakeStatus == 0) {
//
//    parseHandshake(buffer);
//
//    } else {
//    int cmd = buffer.readByte();
//    print("cmd: " + cmd.toString());
//
//    if (cmd == Command.REQUEST_PUBLIC_KEY) {
//    print('peer requested our public key...');
//
//    ECPublicKey publicKey = ConnectionService.nodeId.getKeyPair().publicKey;
//
//    Uint8List encoded = publicKey.Q.getEncoded(false);
//
////          print('my public key ' + encoded.toString());
////          print('my public key ' + encoded.length.toString());
////
////          print('asd ' + hex.encode(publicKey.Q.getEncoded(false)));
////
////          print('asd ' + hex.encode(publicKey.parameters.G.getEncoded(true)));
////          print('asd ' + hex.encode(publicKey.parameters.G.getEncoded(false)));
////
////          print('asd ' +
////              hex.encode(publicKey.parameters.curve.infinity.getEncoded(true)));
//
//    //die letzten 130 bytes nehmen und die parameter....
////          ECPublicKey(Q, publicKey.parameters);
//
////          Digest convert = sha256.convert(publicKey.Q.getEncoded(false));
////
////          String encode = hex.encode(convert.bytes);
//
//    Uint8List publickeybytes = publicKey.Q.getEncoded(false);
//
//    SHA256Digest sha256 = new SHA256Digest();
//
//    Uint8List shaBytes = sha256.process(publickeybytes);
//
//    print('Asdf_ ' + KademliaId.fromFirstBytes(shaBytes).toString());
//    print(hex.encode(publickeybytes));
//
//    print('Asdf22_ ' + hex.encode(shaBytes));
//
//    ByteBuffer byteBuffer = new ByteBuffer(1 + 65);
//    byteBuffer.writeByte(Command.SEND_PUBLIC_KEY);
//    byteBuffer.writeList(encoded);
//
//    socket.add(byteBuffer.buffer.asInt8List());
//    } else if (cmd == Command.SEND_PUBLIC_KEY) {
//    List<int> bytesForPublicKey = buffer.readBytes(NodeId.PUBLIC_KEYLEN);
//
//    NodeId peerNodeId =
//    NodeId.importPublic(Uint8List.fromList(bytesForPublicKey));
//
//    setNodeId(peerNodeId);
//    print('obtained public key from peer: ' +
//    getNodeId().getKademliaId().toString());
//
//    if (_kademliaId != getNodeId().getKademliaId()) {
//    print('wrong public key for node id found, disconnecting...');
//    SentryLogger.log("Error code: g4bdghstg3f4");
//    disconnect();
//    }
//
//    //activate enc todo change to schema from java
//    ByteBuffer byteBuffer = new ByteBuffer(1 + 8);
//    byteBuffer.writeByte(Command.ACTIVATE_ENCRYPTION);
//    //todo add random bytes for iv!
//    socket.add(byteBuffer.buffer.asInt8List());
//
//
//    } else if (cmd == Command.ACTIVATE_ENCRYPTION) {
//    ECPublicKey publicKey = _nodeId.getKeyPair().publicKey;
//
//    Uint8List sharedSecret = generateSharedSecret(
//    ConnectionService.nodeId.getKeyPair(), publicKey.Q);
//    print('intermediateSharedSecret: ' + Utils.hexEncode(sharedSecret));
//    }
//
////        byte command = allocate.get();
////        if (command == Command.REQUEST_PUBLIC_KEY) {
//
//    }
//    } else {
//    //todo parse first enc byte
//    }
  }

  Uint8List getRandomFromUs() {
    randomFromUs ??= Utils.randBytes(IVbytelenHalf);
    return randomFromUs;
  }

  ByteBuffer decrypt(ByteBuffer buffer) {
    Uint8List decBytes = ctrStreamCipherReceive.process(buffer.readBytes(buffer.remaining()));
    return ByteBuffer.fromList(decBytes);
  }

  Future<void> sendEncrypt(ByteBuffer buffer) async {
    Uint8List encBytes = ctrStreamCipherSend.process(buffer.array());

    socket.handleError((e) => {log.finer("error2: " + e.toString())});

    log.finest("trying to add bytes for peer: " + ip);

    socket.add(encBytes);
    await socket.flush();
  }

  void calculateSharedSecret() {
    log.finest('calculateSharedSecret');

    ECPublicKey publicKey = _nodeId.getKeyPair().publicKey;
    Uint8List encoded = generateIntermediateSharedSecret(ConnectionService.nodeId.getKeyPair(), publicKey.Q);

    log.finest('intermediateSharedSecret: ' + Utils.hexEncode(encoded).toString());

    ByteBuffer bytesForPrivateAESKeySend = ByteBuffer(32 + IVbytelen);
    ByteBuffer bytesForPrivateAESKeyReceive = ByteBuffer(32 + IVbytelen);

    bytesForPrivateAESKeySend.writeList(encoded);
    bytesForPrivateAESKeyReceive.writeList(encoded);

    bytesForPrivateAESKeySend.writeList(randomFromUs);
    bytesForPrivateAESKeySend.writeList(randomFromThem);

    bytesForPrivateAESKeyReceive.writeList(randomFromThem);
    bytesForPrivateAESKeyReceive.writeList(randomFromUs);

    sharedSecretSend = Utils.sha256(bytesForPrivateAESKeySend.array());
    sharedSecretReceive = Utils.sha256(bytesForPrivateAESKeyReceive.array());

    ByteBuffer bytesForIVsend = ByteBuffer(IVbytelen);
    ByteBuffer bytesForIVreceive = ByteBuffer(IVbytelen);

    bytesForIVsend.writeList(randomFromUs);
    bytesForIVsend.writeList(randomFromThem);
    bytesForIVreceive.writeList(randomFromThem);
    bytesForIVreceive.writeList(randomFromUs);

    ivSend = bytesForIVsend.array();
    ivReceive = bytesForIVreceive.array();
  }

  void activateEncryption() {
    //todo

    AESFastEngine aesSend = AESFastEngine();
    ctrStreamCipherSend = CTRStreamCipher(aesSend);
    ParametersWithIV parametersWithIVSend = ParametersWithIV(KeyParameter(sharedSecretSend), ivSend);
    ctrStreamCipherSend.init(false, parametersWithIVSend);

    AESFastEngine aesReceive = AESFastEngine();
    ctrStreamCipherReceive = CTRStreamCipher(aesReceive);
    ParametersWithIV parametersWithIVReceive = ParametersWithIV(KeyParameter(sharedSecretReceive), ivReceive);
    ctrStreamCipherReceive.init(false, parametersWithIVReceive);

    isEncryptionActive = true;
  }

  bool hasPublicKey() {
    if (_nodeId == null || _nodeId.getKeyPair() == null) {
      return false;
    }
    return _nodeId.getKeyPair().publicKey != null;
  }

  void sendPublicKeyToPeer() {
    log.finest('sendPublicKeyToPeer...');

    ECPublicKey publicKey = ConnectionService.nodeId.getKeyPair().publicKey;
    Uint8List encoded = publicKey.Q.getEncoded(false);

    ByteBuffer byteBuffer = new ByteBuffer(1 + 65);
    byteBuffer.writeByte(Command.SEND_PUBLIC_KEY);
    byteBuffer.writeList(encoded);

    socket.add(byteBuffer.array());
  }

  bool parseHandshake(ByteBuffer buffer) {
    if (!Utils.listsAreEqual(Utils.MAGIC, buffer.readBytes(4))) {
      log.fine("wrong magic, disconnect!");
      return false;
    }

    int version = buffer.readByte();
    log.finest("version $version");

    int lightClient = buffer.readByte();
    log.finest("lightclient code: $lightClient");

    Uint8List nonce = buffer.readBytes(20);

    log.finest('Found node with id: ' + _kademliaId.toString());

    if (_kademliaId != null && KademliaId.fromBytes(nonce) != _kademliaId) {
      log.info("connected to wrong kadId....");
      disconnect("connected to wrong kadId");
      return false;
    }

    if (_nodeId == null || _nodeId.getKeyPair() == null) {
      //we have to request the public key of the node
      requestPublicKey();
      log.finest('requested public key from peer...');
    } else {
      handshakeStatus = -1;
    }

    return true;
  }

  Uint8List generateIntermediateSharedSecret(AsymmetricKeyPair localPair, ECPoint remotePublicPoint) {
    var ss = remotePublicPoint * (localPair.privateKey as ECPrivateKey).d;
    return hex.decode(toHex(ss.x.toBigInteger()));
  }

  String toHex(BigInt bi) {
    var hex = bi.toRadixString(16);
    return (hex.length & 1 == 0) ? hex : '0$hex';
  }

  void onError(error) {
    log.finer("error found... ${ip} " + error.toString());
  }

  void requestPublicKey() {
    handshakeStatus = 1;

    ByteBuffer byteBuffer = new ByteBuffer(1);
    byteBuffer.writeByte(Command.REQUEST_PUBLIC_KEY);
    socket.add(byteBuffer.array());
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

  NodeId getNodeId() {
    return _nodeId;
  }

  void disconnect(String reason) {
    //todo maybe we need to do some more?

    print("######################## disconnect: $reason ip: $ip ");

    if (socket != null) {
      socket.destroy();
      socket = null;
    }

    // resets all variables such that the handshake can start from beginning
    reset();
  }

  int getIpPortHash() {
    return generateIpPortHash(ip, port);
  }

  static int generateIpPortHash(String ip, int port) {
    //ToDo: we need later a better method
    return ip.hashCode + port;
  }

  void updateKademliaId(KademliaId kademliaId) {
    PeerList.updateKademliaId(this, _kademliaId, kademliaId);
    _kademliaId = kademliaId;
  }

  void setNodeId(NodeId nodeId) {
    _nodeId = nodeId;
  }

  static Uint8List readSignature(ByteBuffer readBuffer) {
    //second byte of encoding gives the remaining bytes of the signature, cf. eg. https://crypto.stackexchange.com/questions/1795/how-can-i-convert-a-der-ecdsa-signature-to-asn-1
    readBuffer.readByte();
    int lenOfSignature = (readBuffer.readByte()) + 2;
    readBuffer.setPosition(readBuffer.position() - 2);

    Uint8List signature = readBuffer.readBytes(lenOfSignature);
    return signature;
  }

  Future<int> readCommand() async {
    int decryptedCommand = decryptBuffer.readUnsignedByte();

    log.finer("received encrypted command: " + decryptedCommand.toString());

    if (decryptedCommand == Command.PING) {
      ByteBuffer byteBuffer = new ByteBuffer(1);
      byteBuffer.writeByte(Command.PONG);
      byteBuffer.flip();

      sendEncrypt(byteBuffer);
      return 1;
    } else if (decryptedCommand == Command.PONG) {
      lastActionOnConnection = new DateTime.now().millisecondsSinceEpoch;
      return 1;
    } else if (decryptedCommand == Command.SEND_PEERLIST) {
      log.finer('received peerlist... ' + ip);

      int toReadBytes = decryptBuffer.readInt();

      List<int> readBytes = decryptBuffer.readBytes(toReadBytes);

      FBPeerList fbPeerList = new FBPeerList(readBytes);

      if (fbPeerList == null || fbPeerList.peers.isEmpty) {
        return 1 + 4 + toReadBytes;
      }

      for (FBPeer fbPeer in fbPeerList.peers) {
        if (fbPeer.nodeId == null) {
          //lets skip peers without a kademliaId...
          continue;
        }

        NodeId nodeId = NodeId.importPublic(Uint8List.fromList(fbPeer.nodeId));

        if (nodeId.getKademliaId() == ConnectionService.kademliaId) {
          //lets not add ourselves...
          continue;
        }

        log.finer("peer in fblist: " + fbPeer.ip + " " + nodeId.getKademliaId().toString());

        PeerList.add(new Peer.withNodeId(fbPeer.ip, fbPeer.port, nodeId));
      }

      return 1 + 4 + toReadBytes;
    } else if (decryptedCommand == Command.KADEMLIA_GET_ANSWER) {
      if (decryptBuffer.remaining() < 4 + 8 + 65 + 4) {
        return 0;
      }

      int ackID = decryptBuffer.readInt();
      int timestamp = decryptBuffer.readLong();
      Uint8List pubkeyBytes = decryptBuffer.readBytes(NodeId.PUBLIC_KEYLEN);

      int contentLength = decryptBuffer.readInt();

      if (decryptBuffer.remaining() < contentLength + 4 + 65) {
        return 0;
      }

      Uint8List content = decryptBuffer.readBytes(contentLength);
      Uint8List signature = readSignature(decryptBuffer);

      KadContent kadContent = new KadContent.withEncryptedData(timestamp, pubkeyBytes, content, signature);

      var channelId = ConnectionService.currentKademliaIdtoChannelId[kadContent.getKademliaId()];
      if (channelId == null) {
        print("we could not map the KademliaId " + channelId.toString() + " to any channel in our db.");
      } else {
        DBChannel channel = await ConnectionService.appDatabase.getChannelById(channelId);
        if (channel == null) {
          log.fine("obtained data for a channel we do not have....");
          return 1 + 4 + 8 + NodeId.PUBLIC_KEYLEN + 4 + contentLength + signature.length;
        }
        await kadContent.decryptWith(new Channel(channel));
        log.finer("obtained KadContent: " +
            kadContent.getKademliaId().toString() +
            " " +
            formatDate(
                DateTime.fromMillisecondsSinceEpoch(
                  kadContent.timestamp,
                ),
                [HH, ':', nn, ':', ss]));

        var channelDataString = Utils.decodeUTF8(kadContent.getContent());
        var decoded = jsonDecode(channelDataString);

        // lets save the the channel data in the db
        var chan = new Channel(channel);
        chan.setChannelData(decoded);
        await chan.saveChannelData(ConnectionService.appDatabase);

        String text;
        int from;
        for (var msg in decoded['msgs']) {
          int messageId = msg['id'];
          text = msg['content'];
          from = msg['from'];
          int timestamp = msg['timestamp'];
          var i = await ConnectionService.appDatabase.dBMessagesDao
              .updateMessage(channelId, messageId, 0, text, from, timestamp);
          if (i != null) {
            refreshMessagesWatching(channelId, messageId: messageId, channelName: channel.name);
            await ConnectionService.appDatabase.updateLastMessage(channelId, from, text, timestamp);
          }
        }

        Map<String, dynamic> userdatas = decoded['userdata'];
        if (userdatas != null) {
          for (MapEntry<String, dynamic> ud in userdatas.entries) {
            int userid = int.parse(ud.key);
            String nick = ud.value['nick'];
            int timestamp = ud.value['generated'];
            log.finest("found nick for $userid in dht entry: $nick");
            await ConnectionService.appDatabase.dBFriendsDao.updateFriend(userid, nick);
          }
        }
      }

      return 1 + 4 + 8 + NodeId.PUBLIC_KEYLEN + 4 + contentLength + signature.length;
    } else if (decryptedCommand == Command.JOB_ACK) {
      var ackId = decryptBuffer.readInt();
      return 1 + 4;
    }

    if (decryptedCommand == Command.REQUEST_PEERLIST || decryptedCommand == Command.UPDATE_REQUEST_TIMESTAMP) {
      //commands are not supported for light clients,
      //todo do not send to light clients....
      return 1;
    }

    if (decryptedCommand == Command.FLASCHENPOST_PUT) {
      print("cmd FLASCHENPOST_PUT should not be send to us since we are a light client");
      int contentLen = decryptBuffer.readInt();
      if (decryptBuffer.remaining() < contentLen) {
        return 0;
      }
      decryptBuffer.readBytes(contentLen);
      return 1 + 4 + contentLen;
    }

    print("could not parse cmd: " + decryptedCommand.toString());
    disconnect("could not parse cmd: " + decryptedCommand.toString());
    throw new Exception("could not parse cmd: " + decryptedCommand.toString());
//    return 0;
  }
}
