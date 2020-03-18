import 'dart:convert';
import 'dart:typed_data';

import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:test/test.dart';

void main() {
  group('NodeId Group Tests', () {
    setUp(() {});

    test('Test export and importPublic', () {
      NodeId nodeId = NodeId.withNewKeyPair();
      Uint8List bytes = nodeId.exportPublic();

      NodeId nodeIdonlyPublic = NodeId.importPublic(bytes);

      expect(Utils.listsAreEqual(nodeIdonlyPublic.exportPublic(), bytes), true);
    });

    test('Test export and import private', () {
      NodeId nodeId = NodeId.withNewKeyPair();
      Uint8List bytes = nodeId.exportWithPrivate();

      NodeId nodeIdImported = NodeId.importWithPrivate(bytes);

      expect(Utils.listsAreEqual(nodeIdImported.exportWithPrivate(), bytes), true);
    });

    test('Test signature and verify', () {
      NodeId nodeId = NodeId.withNewKeyPair();

      final message = Utf8Codec().encode("k3gV");

      var signature = nodeId.sign(message);
      bool verified = nodeId.verify(message, signature);

      expect(verified, true);
    });
  });
}
