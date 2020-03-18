import 'package:moor/moor.dart';

/**
 * Sqlite schema for Channels, will generate a class Channel which then holds
 * all data for the communication.
 */
class DBPeers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get ip => text().withLength(min: 3, max: 32)();

  IntColumn get port => integer()();

  IntColumn get retries => integer().withDefault(const Constant(0))();

  IntColumn get knownSince => integer()();

  BlobColumn get kademliaId => blob()();

  BlobColumn get publicKey => blob()();
}
