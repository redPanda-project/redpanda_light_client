import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/Command.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

class KadContent {
//    public static final int PUBKEY_LEN = 33;
//    public static final int SIGNATURE_LEN = 64;

  KademliaId
      _id; //we store the ID duplicated because of performance reasons (new lookup in the hashmap costs more than a bit of memory)
  int timestamp; //created at (or updated)
  Uint8List pubkey;
  Uint8List _content;
  Uint8List _signature;
  bool _encrypted = false;

  KadContent(this.timestamp, this.pubkey, this._content);

  KadContent.createNow(this.pubkey, this._content) {
    timestamp = Utils.getCurrentTimeMillis();
  }

  KadContent.withEncryptedData(this.timestamp, this.pubkey, this._content, this._signature) {
    _encrypted = true;
  }

  /**
   * KademliaId has to be computed from timestamp and pubkey to verify write permissions and support key rotation.
   */
  KademliaId getKademliaId() {
    _id ??= createKademliaId(timestamp, pubkey);
    return _id;
  }

  static KademliaId createKademliaId(int timestamp, Uint8List pubkey) {
    final formattedStr =
        formatDate(DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true), [dd, '.', mm, '.', yy]);

    List<int> formatedTimeBytes = formattedStr.codeUnits;

    ByteBuffer byteBuffer = ByteBuffer(formatedTimeBytes.length + pubkey.length);
    byteBuffer.writeList(formatedTimeBytes);
    byteBuffer.writeList(pubkey);

    Uint8List sha256 = Utils.sha256(byteBuffer.array());
    return KademliaId.fromFirstBytes(sha256);
  }

  Uint8List getSignature() {
    if (_signature == null) {
      throw new Exception("this content was not signed, signature is null!");
//      return null;
    }

    //lets try to parse the signature....

    var byteBuffer = ByteBuffer.fromList(_signature);

    byteBuffer.readByte();
    int lenOfSignature = byteBuffer.readByte() + 2;

    if (_signature.length != lenOfSignature) {
      throw new Exception("signature wrong format... expected lenOfSignature: $lenOfSignature");
    }

    return _signature;
  }

  Uint8List createHash() {
    ByteBuffer buffer = ByteBuffer(8 + _content.length);
    buffer.writeLong(timestamp);
    buffer.writeList(_content);

    return Utils.sha256(buffer.array());
  }

  /**
   * Encrypts the content of this KadContent with the provided Channel.
   * The local variable _content is overwritten with the encrypted content and the _encrypted flag is set to true.
   */
  Future<void> encryptWith(Channel channel) async {
    var iv = Utils.getSecureRandom().nextBytes(16);

    var encryptAES = channel.encryptAES(_content, iv);

    var ivAndContentBuffer = ByteBuffer(iv.length + encryptAES.length);

    ivAndContentBuffer.writeList(iv);
    ivAndContentBuffer.writeList(encryptAES);

    _encrypted = true;
    _content = ivAndContentBuffer.array();
  }

  /**
   * Decrypts the content of this KadContent with the provided Channel.
   * The local variable _content is overwritten with the decrypted content and the _encrypted flag is set to false.
   */
  Future<void> decryptWith(Channel channel) async {
    ByteBuffer buffer = ByteBuffer.fromList(_content);

    Uint8List iv = buffer.readBytes(16);
    Uint8List contentBytes = buffer.readBytes(buffer.remaining());

    Uint8List decryptAES = channel.decryptAES(contentBytes, iv);

    _encrypted = false;
    _content = decryptAES;
  }

  /**
   * The signature with the given NodeId is calculated and stored in the local variable _signature.
   * Note that the public key of the Keypair of the NodeId has to coincide with the already provided public key,
   * otherwise an exception is thrown.
   */
  Future<void> signWith(NodeId nodeId) async {
    if (!_encrypted) {
      throw new Exception('KadContent has to be encrypted before signing!');
    }
    if (!Utils.listsAreEqual(nodeId.exportPublic(), pubkey)) {
      throw new Exception('Public key of the NodeId has to coincide with the local pubkey of this object!');
    }
    Uint8List hash = createHash();
    _signature = nodeId.sign(hash);
  }

  bool verify() {
    var hash = createHash();
    NodeId pubNodId = NodeId.importPublic(pubkey);
    return pubNodId.verify(hash, getSignature());
  }

  ByteBuffer toCommand() {
    if (!_encrypted) {
      throw new Exception('KadContent has to be encrypted before writing to a peer!');
    }

    if (_signature == null) {
      throw new Exception('KadContent has to be signed before writing to a peer!');
    }

    ByteBuffer writeBuffer =
        ByteBuffer(1 + 4 + 4 + 8 + NodeId.PUBLIC_KEYLEN + 4 + _content.length + 4 + getSignature().length);
    writeBuffer.writeByte(Command.KADEMLIA_STORE);
    writeBuffer.writeInt(4 + 8 + NodeId.PUBLIC_KEYLEN + 4 + _content.length + 4 + getSignature().length);
    writeBuffer.writeInt(Utils.random.nextInt(6000)); //todo check for ack with this id?
//    writeBuffer.writeList(getKademliaId().bytes);
    writeBuffer.writeLong(timestamp);
    writeBuffer.writeList(pubkey);
    writeBuffer.writeInt(_content.length);
    writeBuffer.writeList(_content);
    writeBuffer.writeInt(getSignature().length);
    writeBuffer.writeList(getSignature());

    //todo can be removed later
    if (writeBuffer.position() != writeBuffer.length) {
      var ex = new Exception("ByteBuffer for KadContent cmd was wrong!");
      ConnectionService.sentry.captureException(exception: ex);
      throw ex;
    }

    return writeBuffer;
  }

  Uint8List getContent() {
    return _content;
  }
}
