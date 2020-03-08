import 'dart:math';
import 'dart:typed_data';

import 'package:base58check/base58.dart';
import 'package:cryptography/math.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';


class KademliaId {
  static final int ID_LENGTH = 160;
  static final int ID_LENGTH_BYTES = (ID_LENGTH / 8).round();
  Uint8List _bytes;

  KademliaId.fromBytes(this._bytes);

  KademliaId.fromString(String string) {
    _bytes = Utils.base58decode(string);
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
}
