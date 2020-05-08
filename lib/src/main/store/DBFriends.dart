import 'package:moor/moor.dart';

/**
 * Sqlite schema for Friends.
 */
class DBFriends extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text().nullable().withLength(min: 1, max: 32)();

  BlobColumn get image => blob().nullable()();

  TextColumn get phoneNumber => text().nullable().withLength(min: 6, max: 16)();

  TextColumn get eMail => text().nullable().withLength(min: 6, max: 16)();
}
