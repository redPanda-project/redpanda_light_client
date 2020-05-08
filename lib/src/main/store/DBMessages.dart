import 'package:moor/moor.dart';

/**
 * Sqlite schema for Messages.
 */
class DBMessages extends Table {
  /**
   * Message id has to be unique for all memebers of the Channel. Thus, we have to generate a random interger for the
   * message id.
   */
  IntColumn get messageId => integer()();

  IntColumn get channelId => integer()();

  IntColumn get timestamp => integer()();

  IntColumn get type => integer()();

  TextColumn get content => text().nullable().withLength(min: 1, max: 1024)();

  IntColumn get from => integer()();

  TextColumn get deliveredTo => text().nullable()();

  BoolColumn get read => boolean().withDefault(const Constant(false))();
}
