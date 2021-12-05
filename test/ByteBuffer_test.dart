import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/ByteBuffer.dart';
import 'package:test/test.dart';

AppDatabase appDatabase;

void main() {
  group('A group of tests', () {
    setUp(() async {});

    test('Test simple flip and compact', () async {
      var byteBuffer = new ByteBuffer(32);
      byteBuffer.writeInt(6);
      byteBuffer.writeInt(86);
      expect(byteBuffer.position(), 8);

      byteBuffer.flip();
      byteBuffer.compact();

      expect(byteBuffer.position(), 8);
    });

    test('Test flip and compact with read', () async {
      var byteBuffer = new ByteBuffer(32);
      byteBuffer.writeInt(6);
      byteBuffer.writeInt(86);
      expect(byteBuffer.position(), 8);

      byteBuffer.flip();
      expect(byteBuffer.readInt(), 6);
      byteBuffer.compact();

      expect(byteBuffer.position(), 4);
      byteBuffer.flip();
      expect(byteBuffer.readInt(), 86);
      byteBuffer.compact();

      expect(byteBuffer.position(), 0);
    });
  });
}
