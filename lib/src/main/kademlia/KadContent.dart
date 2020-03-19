import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/Command.dart';
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

  /**
   * KademliaId has to be computed from timestamp and pubkey to verify write permissions and support key rotation.
   */
  KademliaId getKademliaId() {
    if (_id == null) {
      final formattedStr = formatDate(DateTime.fromMillisecondsSinceEpoch(timestamp), [dd, '.', mm, '.', yy]);

      List<int> formatedTimeBytes = formattedStr.codeUnits;

      ByteBuffer byteBuffer = ByteBuffer(formatedTimeBytes.length + pubkey.length);
      byteBuffer.writeList(formatedTimeBytes);
      byteBuffer.writeList(pubkey);

      Uint8List sha256 = Utils.sha256(byteBuffer.array());

      _id = KademliaId.fromFirstBytes(sha256);
    }

    return _id;
  }

  Uint8List getSignature() {
    if (_signature == null) {
//      throw new RuntimeException("this content was not signed, signature is null!");
      return null;
    }
    return _signature;
  }

  Uint8List createHash() {
    ByteBuffer buffer = ByteBuffer(8 + _content.length);
    buffer.writeLong(timestamp);
    buffer.writeList(_content);

    return Utils.sha256(buffer.array());
  }

  Future<void> encryptWith(Channel channel) async {
    var iv = Utils.getSecureRandom().nextBytes(16);

    var encryptAES = channel.encryptAES(_content, iv);

    var ivAndContentBuffer = ByteBuffer(iv.length + encryptAES.length);

    ivAndContentBuffer.writeList(iv);
    ivAndContentBuffer.writeList(encryptAES);

    _encrypted = true;
    _content = ivAndContentBuffer.array();
  }

  Future<void>  signWith(NodeId nodeId) async {
    if (!_encrypted) {
      throw new Exception('KadContent has to be encrypted before signing!');
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

    ByteBuffer writeBuffer = ByteBuffer(
        1 + 4 + KademliaId.ID_LENGTH_BYTES + 8 + pubkey.length + 4 + _content.length + getSignature().length);
    writeBuffer.writeByte(Command.KADEMLIA_STORE);
    writeBuffer.writeInt(Utils.random.nextInt(6000)); //todo check for ack with this id?
    writeBuffer.writeList(getKademliaId().bytes);
    writeBuffer.writeLong(timestamp);
    writeBuffer.writeList(pubkey);
    writeBuffer.writeInt(_content.length);
    writeBuffer.writeList(_content);
    writeBuffer.writeList(getSignature());

    //todo can be removed later
    if (writeBuffer.offset != writeBuffer.length) {
      throw new Exception("ByteBuffer for KadContent cmd was wrong!");
    }

    return writeBuffer;
  }
}
