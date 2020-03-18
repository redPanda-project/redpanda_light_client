import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/store/DBChannels.dart';

/**
 * Here we define the tables in the sqlite database. The code can be generated with
 * pub run build_runner build
 * This will generate the file moor_database.g.dart which will then be used by dart
 */
part 'moor_database.g.dart';

// this will generate a table called LocalSettings for us. The rows of that table will
// be represented by a class called LocalSetting.
// Note the tables are plural (with s) and the class which will hold the data without s
class LocalSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  BlobColumn get privateKey => blob()();

  BlobColumn get kademliaId => blob()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [LocalSettings, DBChannels])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered below.
  @override
  int get schemaVersion => 12;

  Future<LocalSetting> get getLocalSettings => select(localSettings).getSingle();

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

    await migrator.createAll();
  }

  // watches all Channel entries. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<List<DBChannel>> watchDBChannelEntries() {
    return select(dBChannels).watch();
  }

  /**
   * Returns the id of the new channel in db, uses only the channel name for insert and generates a new sharedSecret
   * and private key for the NodeId.
   */
  Future<int> createNewChannel(String name) async {
    var nodeId = new NodeId.withNewKeyPair();

    DBChannelsCompanion entry =
        DBChannelsCompanion.insert(name: name, sharedSecret: Utils.randBytes(32), nodeId: nodeId.exportWithPrivate());
    print("insert channel");
    return into(dBChannels).insert(entry);
  }

  Future<int> removeChannel(int id) async {
    return (delete(dBChannels)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> renameChannel(int id, String newname) async {
    return (update(dBChannels)..where((tbl) => tbl.id.equals(id))).write(DBChannelsCompanion(name: Value(newname)));
  }

  Future<int> updateChannelData(int id, String channelDataString) async {
    return (update(dBChannels)..where((tbl) => tbl.id.equals(id)))
        .write(DBChannelsCompanion(channelData: Value(channelDataString)));
  }

  Future<DBChannel> getChannelById(int id) {
    return (select(dBChannels)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<List<DBChannel>> getAllChannels() {
    return select(dBChannels).get();
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
