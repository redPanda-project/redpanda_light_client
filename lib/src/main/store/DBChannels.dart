import 'package:moor/moor.dart';

/**
 * Sqlite schema for Channels, will generate a class Channel which then holds
 * all data for the communication.
 */
class DBChannels extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 3, max: 32)();

  BlobColumn get sharedSecret => blob()();

  TextColumn get lastMessage_text => text().nullable().withLength()();

  TextColumn get lastMessage_user => text().nullable().withLength()();
}
