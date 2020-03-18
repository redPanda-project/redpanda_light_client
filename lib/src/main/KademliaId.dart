import 'dart:typed_data';

import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';

class KademliaId {
  static final int ID_LENGTH = 160;
  static final int ID_LENGTH_BYTES = (ID_LENGTH / 8).round();
  Uint8List _bytes;

  KademliaId.fromBytes(this._bytes);

  KademliaId.fromString(String string) {
    _bytes = Utils.base58decode(string);
  }

  KademliaId.fromFirstBytes(Uint8List bytes) {
    this._bytes = ByteBuffer.fromBuffer(bytes.buffer, 0, ID_LENGTH_BYTES)
        .readBytes(ID_LENGTH_BYTES);
  }

  KademliaId() {
    this._bytes = Utils.randBytes(ID_LENGTH_BYTES);
    print('new kadid: ' + toString());
  }

  Uint8List get bytes => _bytes;

  /**
   * Obtains a base58 representation of the bytes.
   */
  @override
  String toString() {
    return Utils.base58encode(_bytes);
  }

  /**
   * Equals operator checks for same bytes for the KademliaId.
   */
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KademliaId &&
          runtimeType == other.runtimeType &&
          Utils.listsAreEqual(_bytes, other._bytes);

  @override
  int get hashCode => _bytes.hashCode;
}
