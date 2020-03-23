import 'package:moor/moor.dart';

/**
 * Sqlite schema for Messages.
 */
class DBMessages extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get channelId => integer()();

  IntColumn get timestamp => integer()();

  IntColumn get type => integer()();

  TextColumn get content => text().nullable().withLength(min: 1, max: 1024)();

  IntColumn get from => integer()();

  BoolColumn get delivered => boolean().withDefault(const Constant(false))();

  BoolColumn get read => boolean().withDefault(const Constant(false))();
}
