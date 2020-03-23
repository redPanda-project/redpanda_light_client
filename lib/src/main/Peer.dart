import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' hide ByteBuffer;
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
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

import 'package:convert/convert.dart';
import 'package:redpanda_light_client/src/main/commands/FBPeerList_im.redpanda.commands_generated.dart';
import 'package:redpanda_light_client/src/main/kademlia/KadContent.dart';

class Peer {
  static final log = Logger('Peer');
  static final int IVbytelen = 16;
  static final int IVbytelenHalf = 8;

  String _ip;
  int _port;
  int restries = 0;

  bool connecting = false;
  bool connected = false;
  bool isEncryptionActive = false;
  int handshakeStatus = 0;
  bool waitingForEncryption = false;
  bool weSendOurRandom = false;

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

  Peer.withKademliaId(this._ip, this._port, this._kademliaId);

  String get ip => _ip;

  int get port => _port;

  set ip(String value) {
    _ip = value;
  }

  set port(int value) {
    _port = value;
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
      ByteBuffer decryptBuffer = decrypt(buffer);

      int decryptedCommand = decryptBuffer.readByte();

//      print("received encrypted command: " + decryptedCommand.toString());
//      print('on data: ' + decryptBuffer.array().toString());

      if (decryptedCommand == Command.PING) {
//        print("received ping...");
        ByteBuffer byteBuffer = new ByteBuffer(1);
        byteBuffer.writeByte(Command.PONG);
        byteBuffer.flip();

        sendEncrypt(byteBuffer);
//        print('ponged peer...');
      } else if (decryptedCommand == Command.PONG) {
        lastActionOnConnection = new DateTime.now().millisecondsSinceEpoch;
//        print('received pong...');
      } else if (decryptedCommand == Command.SEND_PEERLIST) {
        log.finer('received peerlist... ' + ip);

        int toReadBytes = decryptBuffer.readInt();

        List<int> readBytes = decryptBuffer.readBytes(toReadBytes);

        FBPeerList fbPeerList = new FBPeerList(readBytes);

        if (fbPeerList == null || fbPeerList.peers.isEmpty) {
          return;
        }

        for (FBPeer fbPeer in fbPeerList.peers) {
          if (fbPeer.nodeId == null) {
            //lets skip peers without a kademliaId...
            continue;
          }

          KademliaId kademliaId = KademliaId.fromBytes(Uint8List.fromList(fbPeer.nodeId));

          if (kademliaId == ConnectionService.kademliaId) {
            //lets not add ourselves...
            continue;
          }

          log.finer("peer in fblist: " + fbPeer.ip + " " + kademliaId.toString());

          PeerList.add(new Peer.withKademliaId(fbPeer.ip, fbPeer.port, kademliaId));
        }
      } else if (decryptedCommand == Command.KADEMLIA_GET_ANSWER) {
        int ackID = decryptBuffer.readInt();
//        KademliaId kademliaId = new KademliaId.fromBytes(decryptBuffer.readBytes(KademliaId.ID_LENGTH));
        int timestamp = decryptBuffer.readLong();
        Uint8List pubkeyBytes = decryptBuffer.readBytes(NodeId.PUBLIC_KEYLEN);
        int contentLength = decryptBuffer.readInt();
        Uint8List content = decryptBuffer.readBytes(contentLength);
        Uint8List signature = readSignature(decryptBuffer);

        KadContent kadContent = new KadContent.withEncryptedData(timestamp, pubkeyBytes, content, signature);

        var channelId = ConnectionService.currentKademliaIdtoChannelId[kadContent.getKademliaId()];
        if (channelId == null) {
          print("we could not map the KademliaId " + channelId.toString() + " to any channel in our db.");
        } else {
          DBChannel channel = await ConnectionService.appDatabase.getChannelById(channelId);
          await kadContent.decryptWith(new Channel(channel));
          print("obtained KadContent: " + kadContent.getKademliaId().toString());

          var channelDataString = Utils.decodeUTF8(kadContent.getContent());
          var decoded = jsonDecode(channelDataString);

          print("obtained KadContent: ");
          print(decoded);

//          print("object")
        }
      }

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

          if (_kademliaId != peerNodeId.getKademliaId()) {
            /**
             * We obtained a public key which does not match the KademliaId of this Peer
             * and should cancel that connection here.
             */
            log.warning('wrong public key for node id found, disconnecting...');
            handshakeStatus = 2;
            SentryLogger.log("Error code: g4bdghstg3f4");
            disconnect();
          } else {
            /**
             * We obtained the correct public key and can add it to the Peer
             * and lets set that peerInHandshake status to waiting for encryption
             */
            setNodeId(peerNodeId);
            handshakeStatus = -1;
          }
        } else if (command == Command.ACTIVATE_ENCRYPTION) {
          /**
           * We received the byte to activate the encryption and we are awaiting the encryption activation byte
           */

          //lets read the random bytes from them
          if (buffer.remaining() < IVbytelenHalf) {
            log.warning("not enough bytes for encryption... " + buffer.remaining().toString());
            disconnect();
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

      ByteBuffer decryptBuffer = decrypt(buffer);

      int decryptedCommand = decryptBuffer.readByte();

      if (decryptedCommand == Command.PING) {
        log.finer("received first ping...");

        /**
         * We can now safely transfer the open connection from the peerInHandshake to the
         * actual peer
         */

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
//    print('len bytes to send enc: ' + buffer.remaining().toString() + " cmd: " + buffer.array().toString());

    Uint8List encBytes = await ctrStreamCipherSend.process(buffer.array());

//    print('len bytes to send enc: ' + encBytes.length.toString());

//    print('enc cmd: ' + encBytes.toString());

    socket.handleError((e) => {log.finer("error2: " + e.toString())});

    log.finest("trying to add bytes for peer: " + ip);

    await socket.add(encBytes);
    await socket.flush();
  }

  void calculateSharedSecret() {
    log.finest('calculateSharedSecret');

    ECPublicKey publicKey = _nodeId.getKeyPair().publicKey;
    Uint8List encoded = generateIntermediateSharedSecret(ConnectionService.nodeId.getKeyPair(), publicKey.Q);

    log.finest('intermediateSharedSecret: ' + Utils.hexEncode(encoded).toString());

    ByteBuffer bytesForPrivateAESkeySend = ByteBuffer(32 + IVbytelen);
    ByteBuffer bytesForPrivateAESkeyReceive = ByteBuffer(32 + IVbytelen);

    bytesForPrivateAESkeySend.writeList(encoded);
    bytesForPrivateAESkeyReceive.writeList(encoded);

    bytesForPrivateAESkeySend.writeList(randomFromUs);
    bytesForPrivateAESkeySend.writeList(randomFromThem);

    bytesForPrivateAESkeyReceive.writeList(randomFromThem);
    bytesForPrivateAESkeyReceive.writeList(randomFromUs);

    sharedSecretSend = Utils.sha256(bytesForPrivateAESkeySend.array());
    sharedSecretReceive = Utils.sha256(bytesForPrivateAESkeyReceive.array());

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

//    print('activateEncryption');

    AESFastEngine aesSend = AESFastEngine();
    ctrStreamCipherSend = CTRStreamCipher(aesSend);
    ParametersWithIV parametersWithIVSend = ParametersWithIV(KeyParameter(sharedSecretSend), ivSend);
    ctrStreamCipherSend.init(false, parametersWithIVSend);

//    print('activateEncryption Send succesful');

    AESFastEngine aesReceive = AESFastEngine();
    ctrStreamCipherReceive = CTRStreamCipher(aesReceive);
    ParametersWithIV parametersWithIVReceive = ParametersWithIV(KeyParameter(sharedSecretReceive), ivReceive);
    ctrStreamCipherReceive.init(false, parametersWithIVReceive);

//    print('activateEncryption Receive succesful');

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
    //    print(buffer.readBytes(4));
    if (!Utils.listsAreEqual(Utils.MAGIC, buffer.readBytes(4))) {
      log.fine("wrong magic, disconnect!");
      return false;
    }

    int version = buffer.readByte();
    log.finest("version $version");

    int lightClient = buffer.readByte();
    log.finest("lightclient code: $lightClient");

    Uint8List nonce = buffer.readBytes(20);
//    print("server identity: " + HEX.encode(nonce).toUpperCase());

    updateKademliaId(new KademliaId.fromBytes(nonce));

    log.finest('Found node with id: ' + _kademliaId.toString());

    if (_nodeId == null || _nodeId.getKeyPair() == null) {
      //we have to request the public key of the node
      requestPublicKey();
      log.finest('requested public key from peer...');
    } else {
      handshakeStatus = -1;
    }

//    print(buffer.readUnsignedShort());
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

//  @override
//  bool operator ==(other) {
//    Peer otherPeer = other as Peer;
//
//    //todo add port...
//    if (otherPeer.ip == ip) {
//      return true;
//    }
//  }

  void onError(error) {
//    print("error found: $error");
    log.fine("error found... ${ip} " + error.toString());
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

  void setNodeId(NodeId peerNodeId) {
    _nodeId = peerNodeId;
  }

  NodeId getNodeId() {
    return _nodeId;
  }

  void disconnect() {
    //todo maybe we need to do some more?

    if (socket != null) {
//      socket.close();
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

  static Uint8List readSignature(ByteBuffer readBuffer) {
    //second byte of encoding gives the remaining bytes of the signature, cf. eg. https://crypto.stackexchange.com/questions/1795/how-can-i-convert-a-der-ecdsa-signature-to-asn-1
    readBuffer.readByte();
    int lenOfSignature = (readBuffer.readByte()) + 2;
    readBuffer.offset = readBuffer.offset - 2;

    Uint8List signature = readBuffer.readBytes(lenOfSignature);
    return signature;
  }
}
