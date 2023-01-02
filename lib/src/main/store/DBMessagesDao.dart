import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/store/DBFriends.dart';
import 'package:redpanda_light_client/src/main/store/DBMessageWithFriend.dart';
import 'package:redpanda_light_client/src/main/store/DBMessages.dart';

part 'DBMessagesDao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [DBMessages, DBFriends])
class DBMessagesDao extends DatabaseAccessor<AppDatabase> with _$DBMessagesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  DBMessagesDao(AppDatabase db) : super(db);

  // watches all Messages for a given channel id. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<List<DBMessage>> watchDBMessageEntries(int channelId) {
    return (select(dBMessages)..where((tbl) => tbl.channelId.equals(channelId))).watch();
  }

  // get all Messages for a given channel id. The stream will automatically
  // emit new items whenever the underlying data changes.
  Future<List<DBMessageWithFriend>> getAllDBMessages(int channelId) async {
    final rows = await ((select(dBMessages)..where((tbl) => tbl.channelId.equals(channelId)))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .join([
      leftOuterJoin(dBFriends, dBFriends.id.equalsExp(dBMessages.from)),
    ]).get();

    var list = rows.map((row) {
      var readTable = row.readTableOrNull(dBMessages);
      return DBMessageWithFriend(readTable, row.readTableOrNull(dBFriends), ConnectionService.myUserId == readTable?.from);
    }).toList();

    return list;
  }

  // get all Messages for a given channel id. The stream will automatically
  // emit new items whenever the underlying data changes.
  Future<DBMessageWithFriend> getMessageById(int messageId) async {
    final row = await ((select(dBMessages)..where((tbl) => tbl.messageId.equals(messageId)))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .join([
      leftOuterJoin(dBFriends, dBFriends.id.equalsExp(dBMessages.from)),
    ]).getSingle();

    var readTable = row.readTable(dBMessages);
    return DBMessageWithFriend(readTable, row.readTable(dBFriends), ConnectionService.myUserId == readTable.from);
  }

  Future<int> writeMessage(int channelId, String text) {
    DBMessagesCompanion entry = DBMessagesCompanion.insert(
        messageId: Utils.randInteger(),
        channelId: channelId,
        content: Value(text),
        from: ConnectionService.myUserId,
//        fromMe: Value(false),
        timestamp: Utils.getCurrentTimeMillis(),
        type: 0);

    print("insert new msg: " + channelId.toString());
    db.updateLastMessageByMe(channelId, text);
    print('updated last message...');
    return into(dBMessages).insert(entry);
  }

  Future<int> updateMessage(int channelId, int messageId, int deliveredTo, String text, int from, int timestamp) async {
    log.finest("update message database: " + messageId.toString() + " " + text);

    bool hadToDelete = false;
    DBMessage? single;
    //if more than one message delete all msg and add below in the update routine
    try {
      single = await (select(dBMessages)..where((tbl) => tbl.messageId.equals(messageId))).getSingleOrNull();
    } on StateError catch (e) {
      (delete(dBMessages)..where((tbl) => tbl.messageId.equals(messageId))).go();
      //let us set single to null such that the the message will be added
      print("had to delete msg, since more than one was found");
      log.finer(e.stackTrace);
      single = null;
      hadToDelete = true;
    }

    if (single != null) {
      bool weHaveToAdd = false;
      var dec = [];

      if (single.deliveredTo != null) {
        dec = jsonDecode(single.deliveredTo!);
        if (!dec.contains(deliveredTo)) {
          weHaveToAdd = true;
        }
      } else {
        weHaveToAdd = true;
      }

      dec.add(deliveredTo);

      if (weHaveToAdd) {
//        print("updated delivered: " + jsonEncode(dec));

        await (update(dBMessages)..where((tbl) => tbl.messageId.equals(messageId)))
            .write(new DBMessagesCompanion(deliveredTo: Value(jsonEncode(dec))));

        return 0;
      } else {
//        print("no new content from dht for msg: " + jsonEncode(dec) + " " + text);
      }

      return 0;
    } else {
      DBMessagesCompanion entry = DBMessagesCompanion.insert(
          messageId: messageId,
          channelId: channelId,
          content: Value(text),
          from: from,
//        fromMe: Value(false),
          timestamp: timestamp,
          type: 0);

      print("insert new msg: " + channelId.toString() + " msgid: " + messageId.toString());

      var a = into(dBMessages).insert(entry);

      if (hadToDelete) {
        return 0;
      }

      return a;
    }
  }
}
