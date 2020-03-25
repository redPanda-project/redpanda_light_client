import 'package:moor/moor.dart';

/**
 * Sqlite schema for Channels, will generate a class Channel which then holds
 * all data for the communication.
 */
class DBPeers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get ip => text().nullable().withLength(min: 3, max: 32)();

  IntColumn get port => integer().nullable()();

  IntColumn get score => integer().withDefault(const Constant(0))();

  IntColumn get knownSince => integer().nullable()();

  BlobColumn get kademliaId => blob().nullable()();

  BlobColumn get publicKey => blob().nullable()();
}
