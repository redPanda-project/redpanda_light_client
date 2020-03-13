import 'dart:io';
import 'dart:math';
import 'dart:typed_data' hide ByteBuffer;
import 'dart:typed_data';

import 'package:buffer/buffer.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Command.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/SentryLogger.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

import 'package:convert/convert.dart';
import 'package:sentry/sentry.dart';
//import 'package:crypto/crypto.dart';

class Peer {
  static final int IVbytelen = 16;
  static final int IVbytelenHalf = 8;

  String _ip;
  int _port;

  bool connecting = false;
  bool connected = false;
  bool isEncryptionActive = false;
  int handshakeStatus = 0;
  bool waitingForEncryption = false;
  bool weSendOurRandom = false;

  Uint8List randomFromThem;
  Uint8List randomFromUs;

  NodeId _nodeId;
  KademliaId _kademliaId;

  int lastActionOnConnection = 0;

  Socket socket;

  Peer(this._ip, this._port);

  String get ip => _ip;

  int get port => _port;

  void ondata(Uint8List data) {
//    print(data.toString());

    ByteDataReader byteDataReader = new ByteDataReader();
    byteDataReader.add(data);

    print('on data: ' + data.toString());

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

    if (!isEncryptionActive) {
      if (handshakeStatus == 0) {
        /**
         * The status indicates that no handshake was parsed before for this PeerInHandshake
         */
        bool b = parseHandshake(buffer);

        print('handshake ok: $b');
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

          NodeId peerNodeId =
              NodeId.importPublic(Uint8List.fromList(bytesForPublicKey));

          print('new nodeid from peer: ' + peerNodeId.toString());

          if (_kademliaId != peerNodeId.getKademliaId()) {
            /**
             * We obtained a public key which does not match the KademliaId of this Peer
             * and should cancel that connection here.
             */
            print('wrong public key for node id found, disconnecting...');
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
            print("not enough bytes for encryption... " +
                buffer.remaining().toString());
            disconnect();
            return;
          }

          List<int> bytesForPublicKey = buffer.readBytes(IVbytelenHalf);

          randomFromThem = Uint8List.fromList(bytesForPublicKey);
          waitingForEncryption = true;

          print('obtained activate enc cmd and bytes for IV');
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
        socket.add(byteBuffer.buffer.asInt8List());

        print("written bytes for ACTIVATE_ENCRYPTION");

        weSendOurRandom = true;
      }

      if (handshakeStatus == -1 && waitingForEncryption && hasPublicKey()) {
        waitingForEncryption = false;

        print("lets generate the shared secret");

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
        socket.add(byteBuffer.buffer.asInt8List());

        sendEncrypt(byteBuffer);
      }
    } else {
      /**
       * The encryption is active in this section, lets check that first ping
       */
      print("received first encrypted command...");

      ByteBuffer decryptBuffer = decrypt(buffer);

      int decryptedCommand = decryptBuffer.readByte();

      if (decryptedCommand == Command.PING) {
        print("received first ping...");

        /**
         * We can now safely transfer the open connection from the peerInHandshake to the
         * actual peer
         */

        //todo setup connection
        connected = true;
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
    if (randomFromUs == null) {
      //todo switch to secure random?
      randomFromUs = Utils.randBytes(IVbytelenHalf);
    }
    return randomFromUs;
  }

  ByteBuffer decrypt(ByteBuffer buffer) {
    //todo
  }

  void sendEncrypt(ByteBuffer buffer) {
    //todo
  }

  void calculateSharedSecret() {
    //todo
  }

  void activateEncryption() {
    //todo
  }

  bool hasPublicKey() {
    if (_nodeId == null || _nodeId.getKeyPair() == null) {
      return false;
    }
    return _nodeId.getKeyPair().privateKey != null;
  }

  void sendPublicKeyToPeer() {
    print('sendPublicKeyToPeer...');

    ECPublicKey publicKey = ConnectionService.nodeId.getKeyPair().publicKey;
    Uint8List encoded = publicKey.Q.getEncoded(false);

    ByteBuffer byteBuffer = new ByteBuffer(1 + 65);
    byteBuffer.writeByte(Command.SEND_PUBLIC_KEY);
    byteBuffer.writeList(encoded);

    socket.add(byteBuffer.buffer.asInt8List());
  }

  bool parseHandshake(ByteBuffer buffer) {
    //    print(buffer.readBytes(4));
    if (!Utils.listsAreEqual(Utils.MAGIC, buffer.readBytes(4))) {
      print("wrong magic, disconnect!");
      return false;
    }

    int version = buffer.readByte();
    print("version $version");

    Uint8List nonce = buffer.readBytes(20);
//    print("server identity: " + HEX.encode(nonce).toUpperCase());

    _kademliaId = new KademliaId.fromBytes(nonce);

    print('Found node with id: ' + _kademliaId.toString());

    if (_nodeId == null || _nodeId.getKeyPair() == null) {
      //we have to request the public key of the node
      requestPublicKey();
      print('requested public key from peer...');
    } else {
      handshakeStatus = -1;
    }

    print(buffer.readUnsignedShort());
    return true;
  }

  Uint8List generateSharedSecret(
      AsymmetricKeyPair localPair, ECPoint remotePublicPoint) {
    var ss = remotePublicPoint * (localPair.privateKey as ECPrivateKey).d;
    return hex.decode(toHex(ss.x.toBigInteger()));
  }

  String toHex(BigInt bi) {
    var hex = bi.toRadixString(16);
    return (hex.length & 1 == 0) ? hex : '0$hex';
  }

  bool operator ==(other) {
    Peer otherPeer = other as Peer;

    //todo add port...
    if (otherPeer.ip == ip) {
      return true;
    }
  }

  void onError(error) {
//    print("error found: $error");
    print("error found...");
  }

  void requestPublicKey() {
    handshakeStatus = 1;

    ByteBuffer byteBuffer = new ByteBuffer(1);
    byteBuffer.writeByte(Command.REQUEST_PUBLIC_KEY);
    socket.add(byteBuffer.buffer.asInt8List());
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
    socket.close();
  }
}
