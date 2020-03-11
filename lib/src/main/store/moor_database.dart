import 'dart:io';

import 'package:moor/moor.dart';
//import 'package:moor/src/utils/lazy_database.dart';

import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:redpanda_light_client/src/main/ConnectionService.dart';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'moor_database.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class LocalSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

//  TextColumn get title => text().withLength(min: 6, max: 32)();
//
//  TextColumn get content => text().named('body')();
//
//  IntColumn get category => integer().nullable()();

  TextColumn get privateKey => text()();

  BlobColumn get kademliaId => blob()();
}

class Channels extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 3, max: 32)();

  TextColumn get lastMessage_text => text().withLength()();

  TextColumn get lastMessage_user => text().withLength()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [LocalSettings, Channels])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 3;

  Future<LocalSetting> get getLocalSettings =>
      select(localSettings).getSingle();

  // returns the generated id
  Future<int> save(Insertable<LocalSetting> entry) async {
    await delete(localSettings).go();
    return into(localSettings).insert(entry);
  }

  @override
  MigrationStrategy get migration => migrate();

  MigrationStrategy migrate() {
    MigrationStrategy s = MigrationStrategy(onUpgrade: onUpgrade);
    return s;
  }

  /**
   * Migration will drop all tables and create database from scratch.
   */
  Future<void> onUpgrade(Migrator migrator, int old, int n) async {
    for (final TableInfo<Table, DataClass> table in this.allTables) {
      await migrator.deleteTable(table.actualTableName);
      print("dropping table " + table.actualTableName);
    }

    migrator.createAll();
  }

  // watches all Channel entries. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<List<Channel>> watchChannelEntries() {
    return select(channels).watch();
  }

  /**
   * Returns the id...
   */
  Future<int> insertChannel(Insertable<Channel> entry) async {
    return into(channels).insert(entry);
  }

  Future<int> removeChannel(int id) async {
    return (delete(channels)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    // for flutter get the path by: final dbFolder = await getApplicationDocumentsDirectory().path;
    final file = File(p.join(ConnectionService.pathToDatabase, 'db.sqlite'));
    return VmDatabase(file);
  });
}
