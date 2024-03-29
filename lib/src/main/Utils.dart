// @dart=2.9
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:base58check/base58.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';

class Utils {
  static Random random = Random.secure();
  static FortunaRandom secureRandom = FortunaRandom();
  static const String _bitcoinAlphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
  static const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  static Base58Codec base58codec = new Base58Codec(_bitcoinAlphabet);
  static final MAGIC = Utf8Codec().encode("k3gV");
  static SHA256Digest sha256Digest = new SHA256Digest();

  static Uint8List randBytes(int n) {
    final Uint8List bytes = Uint8List(n);
    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(255);
    }
    return bytes;
  }

  static String base58encode(Uint8List bytes) {
    return base58codec.encode(bytes);
  }

  static Uint8List base58decode(String string) {
    return base58codec.decode(string);
  }

  static String hexEncode(Uint8List bytes) {
    return hex.encode(bytes);
  }

  static Uint8List hexDecode(String string) {
    return hex.decode(string);
  }

  static Uint8List encodeUTF8(String s) {
    return Utf8Codec().encode(s);
  }

  static String decodeUTF8(Uint8List s) {
    return Utf8Codec().decode(s);
  }

  /**
   * Create sha256 single round of bytes.
   */
  static Uint8List sha256(Uint8List bytes) {
    return sha256Digest.process(bytes);
  }

  static bool listsAreEqual(list1, list2) {
    if (list1.length != list2.length) {
      return false;
    }
    var i = -1;
    return list1.every((val) {
      i++;
      if (val is List && list2[i] is List) {
        return listsAreEqual(val, list2[i]);
      } else {
        return list2[i] == val;
      }
    });
  }

  static SecureRandom getSecureRandom() {
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));
    return secureRandom;
  }

  static int getCurrentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static String randomString(int strlen) {
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }

  /**
   * Generates a random 4 byte integer compatible to java.
   */
  static int randInteger() {
    return Utils.random.nextInt(2147483647 * 2) - 2147483647;
  }
}
