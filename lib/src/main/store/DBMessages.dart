import 'package:moor/moor.dart';

/**
 * Sqlite schema for Messages.
 */
class DBMessages extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get channelId => integer()();

  IntColumn get timestamp => integer()();

  TextColumn get content => text().withLength(min: 3, max: 32)();

  TextColumn get fromName => text().withLength(min: 3, max: 32)();

  BoolColumn get delivered => boolean().withDefault(const Constant(false))();

  BoolColumn get read => boolean().withDefault(const Constant(false))();
}
