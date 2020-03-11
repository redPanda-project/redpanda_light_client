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
  });
}
