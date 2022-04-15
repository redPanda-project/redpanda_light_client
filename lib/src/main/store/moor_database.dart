// @dart=2.9
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/NodeId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/store/DBChannels.dart';
import 'package:redpanda_light_client/src/main/store/DBFriends.dart';
import 'package:redpanda_light_client/src/main/store/DBFriendsDao.dart';
import 'package:redpanda_light_client/src/main/store/DBMessages.dart';
import 'package:redpanda_light_client/src/main/store/DBMessagesDao.dart';
import 'package:redpanda_light_client/src/main/store/DBPeers.dart';
import 'package:redpanda_light_client/src/main/store/DBPeersDao.dart';

/**
 * Here we define the tables in the sqlite database. The code can be generated with
 * pub run build_runner build
 * This will generate the file moor_database.g.dart which will then be used by dart
 */
part 'moor_database.g.dart';

final log = Logger('moor_database');

// this will generate a table called LocalSettings for us. The rows of that table will
// be represented by a class called LocalSetting.
// Note the tables are plural (with s) and the class which will hold the data without s
class LocalSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get myUserId => integer()();

  TextColumn get fcmToken => text().nullable()();

  BlobColumn get privateKey => blob()();

  BlobColumn get kademliaId => blob()();

  TextColumn get defaultName => text().nullable()();

  IntColumn get versionTimestamp => integer().nullable()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(
    tables: [LocalSettings, DBChannels, DBPeers, DBMessages, DBFriends],
    daos: [DBPeersDao, DBMessagesDao, DBFriendsDao])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered below.
  @override
  int get schemaVersion => 47;

  Future<LocalSetting> get getLocalSettings => select(localSettings).getSingleOrNull();

  // returns the generated id
  Future<int> save(Insertable<LocalSetting> entry) async {
    await delete(localSettings).go();
    return into(localSettings).insert(entry);
  }

  Future<int> insertFCMToken(String fcmToken) async {
    return update(localSettings).write(LocalSettingsCompanion(fcmToken: Value(fcmToken)));
  }

  Future<int> setNickname(String nick) async {
    return update(localSettings).write(LocalSettingsCompanion(defaultName: Value(nick)));
  }

  Future<int> setVersionTimestamp(int timestamp) async {
    return update(localSettings).write(LocalSettingsCompanion(versionTimestamp: Value(timestamp)));
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
  Future<void> onUpgrade(Migrator migrator, int from, int n) async {
    if (from < 48) {
      dropAll(migrator, from, n);
    } else {
      dropAllExceptChannelsAndSettings(migrator, from, n);
    }

    await migrator.createAll();
  }

  void dropAll(Migrator migrator, int from, int n) async {
    for (final TableInfo<Table, DataClass> table in allTables) {
      await migrator.deleteTable(table.actualTableName);
      print("dropping table " + table.actualTableName);
    }
  }

  void dropAllExceptChannelsAndSettings(Migrator migrator, int from, int n) async {
    for (final TableInfo<Table, DataClass> table in allTables) {
      if (table.actualTableName.contains("channels") || table.actualTableName.contains("settings")) {
        print("table not dropped!: " + table.actualTableName);
        continue;
      }

      await migrator.deleteTable(table.actualTableName);
      print("dropping table " + table.actualTableName);
    }
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
    log.finest("insert channel");
    return into(dBChannels).insert(entry);
  }

  Future<int> createChannelFromData(String name, Uint8List sharedSecret, Uint8List privateSigningKey) async {
    var nodeId = new NodeId.importWithPrivate(privateSigningKey);
    DBChannelsCompanion entry =
        DBChannelsCompanion.insert(name: name, sharedSecret: sharedSecret, nodeId: nodeId.exportWithPrivate());
    log.finest("insert channel");
    return into(dBChannels).insert(entry);
  }

  Future<int> removeChannel(int id) async {
    return (delete(dBChannels)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> renameChannel(int id, String newname) async {
    return (update(dBChannels)..where((tbl) => tbl.id.equals(id))).write(DBChannelsCompanion(name: Value(newname)));
  }

  Future<int> updateLastMessageByMe(int channelId, String message) async {
    return (update(dBChannels)..where((tbl) => tbl.id.equals(channelId))).write(DBChannelsCompanion(
        lastMessage_user: Value(""),
        lastMessage_text: Value(message),
        lastMessage_timestamp: Value(Utils.getCurrentTimeMillis())));
  }

  Future<int> updateLastMessage(int channelId, int userId, String message, int timestamp) async {
    var dbFriend = await dBFriendsDao.getFriend(userId);

    return (update(dBChannels)..where((tbl) => tbl.id.equals(channelId))).write(DBChannelsCompanion(
        lastMessage_user: Value(dbFriend?.name ?? '?'),
        lastMessage_text: Value(message),
        lastMessage_timestamp: Value(timestamp)));
  }

  Future<int> updateChannelData(int id, String channelDataString) async {
    log.finer('update channel data $channelDataString');
    return (update(dBChannels)..where((tbl) => tbl.id.equals(id)))
        .write(DBChannelsCompanion(channelData: Value(channelDataString)));
  }

  Future<DBChannel> getChannelById(int id) {
    return (select(dBChannels)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<List<DBChannel>> getAllChannels() {
//    return select(dBChannels).get();
    return (select(dBChannels)
          ..orderBy([(t) => OrderingTerm(expression: t.lastMessage_timestamp, mode: OrderingMode.desc)]))
        .get();
  }

//  /**
//   * Returns the id of the new Peer in db.
//   */
//  Future<int> insertNewPeer(String ip, int port, KademliaId kademliaId, Uint8List publicKey) async {
//    DBPeersCompanion entry = DBPeersCompanion.insert(
//        ip: ip,
//        port: port,
//        knownSince: Utils.getCurrentTimeMillis(),
//        kademliaId: kademliaId.bytes,
//        publicKey: publicKey);
//    print("insert peer");
//    return into(dBPeers).insert(entry);
//  }
//
//  Future<DBPeer> getPeerByKademliaId(KademliaId kademliaId) {
//    return (select(dBPeers)..where((tbl) => tbl.kademliaId.equals(kademliaId.bytes))).getSingle();
//  }
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
