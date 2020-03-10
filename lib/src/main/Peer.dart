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
import 'package:redpanda_light_client/src/main/Utils.dart';

import 'package:convert/convert.dart';
//import 'package:crypto/crypto.dart';

class Peer {
  String _ip;
  int _port;

  bool connecting = false;
  bool connected = false;
  bool isEncryptionActive = false;
  int handshakeStatus = 0;
  AsymmetricKeyPair pair;

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
//    print(buffer.readBytes(4));
        if (!Utils.listsAreEqual(Utils.MAGIC, buffer.readBytes(4))) {
          print("wrong magic, disconnect!");
        }

        int version = buffer.readByte();
        print("version $version");

        Uint8List nonce = buffer.readBytes(20);
//    print("server identity: " + HEX.encode(nonce).toUpperCase());

        KademliaId kademliaId = new KademliaId.fromBytes(nonce);

        print('Found node with id: ' + kademliaId.toString());

        if (pair == null) {
          //we have to request the public key of the node
          requestPublicKey();
          print('requested public key from peer...');
        } else {
          handshakeStatus = -1;
        }

        print(buffer.readUnsignedShort());
      } else {
        int cmd = buffer.readByte();
        print("cmd: " + cmd.toString());

        if (cmd == Command.REQUEST_PUBLIC_KEY) {
          print('peer requested our public key...');

          ECPublicKey publicKey = ConnectionService.nodeKey.publicKey;

          Uint8List encoded = publicKey.Q.getEncoded(false);



//          print('my public key ' + encoded.toString());
//          print('my public key ' + encoded.length.toString());
//
//          print('asd ' + hex.encode(publicKey.Q.getEncoded(false)));
//
//          print('asd ' + hex.encode(publicKey.parameters.G.getEncoded(true)));
//          print('asd ' + hex.encode(publicKey.parameters.G.getEncoded(false)));
//
//          print('asd ' +
//              hex.encode(publicKey.parameters.curve.infinity.getEncoded(true)));

          //die letzten 130 bytes nehmen und die parameter....
//          ECPublicKey(Q, publicKey.parameters);

//          Digest convert = sha256.convert(publicKey.Q.getEncoded(false));
//
//          String encode = hex.encode(convert.bytes);

          Uint8List publickeybytes = publicKey.Q.getEncoded(false);

          SHA256Digest sha256 = new SHA256Digest();

          Uint8List shaBytes = sha256.process(publickeybytes);

          print('Asdf_ ' + KademliaId.fromFirstBytes(shaBytes).toString());
          print(hex.encode(publickeybytes));

          print('Asdf22_ ' + hex.encode(shaBytes));

          ByteBuffer byteBuffer = new ByteBuffer(1 + 65);
          byteBuffer.writeByte(Command.SEND_PUBLIC_KEY);
          byteBuffer.writeList(encoded);

          socket.add(byteBuffer.buffer.asInt8List());
        }

//        byte command = allocate.get();
//        if (command == Command.REQUEST_PUBLIC_KEY) {

      }
    } else {
      //todo parse first enc byte
    }
  }

  bool operator ==(other) {
    Peer otherPeer = other as Peer;

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
}
