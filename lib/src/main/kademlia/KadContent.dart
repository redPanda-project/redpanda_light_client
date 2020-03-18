import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
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
  Uint8List content;
  Uint8List _signature;

  KadContent(this.timestamp, this.pubkey, this.content);

  KadContent.createNow(this.pubkey, this.content) {
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

      _id = KademliaId.fromBytes(sha256);
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
    ByteBuffer buffer = ByteBuffer(8 + content.length);
    buffer.writeLong(timestamp);
    buffer.writeList(content);

    return Utils.sha256(buffer.array());
  }

  void signWith(NodeId nodeId) {
    Uint8List hash = createHash();
    _signature = nodeId.sign(hash);
  }

  bool verify() {
    var hash = createHash();
    NodeId pubNodId = NodeId.importPublic(pubkey);
    return pubNodId.verify(hash, getSignature());
  }
}
