import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/store/DBFriends.dart';
import 'package:redpanda_light_client/src/main/store/DBMessageWithFriend.dart';
import 'package:redpanda_light_client/src/main/store/DBMessages.dart';


part 'DBMessagesDao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [DBMessages, DBFriends])
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
      var readTable = row.readTable(dBMessages);
      return DBMessageWithFriend(readTable, row.readTable(dBFriends), ConnectionService.myUserId == readTable.from);
    }).toList();

    return list;
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

    return into(dBMessages).insert(entry);
  }

  Future<int> updateMessage(int channelId, int messageId, int deliveredTo, String text, int from, int timestamp) async {
    print("hagdhjasgdhjasgd update message: " + messageId.toString() + " " + text);

    var single = await (select(dBMessages)..where((tbl) => tbl.messageId.equals(messageId))).getSingle();

    if (single != null) {
      bool weHaveToAdd = false;
      var dec = [];

      if (single.deliveredTo != null) {
        dec = jsonDecode(single.deliveredTo);
        if (!dec.contains(deliveredTo)) {
          weHaveToAdd = true;
        }
      } else {
        weHaveToAdd = true;
      }

      dec.add(deliveredTo);

      if (weHaveToAdd) {
        print("updated delivered: " + jsonEncode(dec));

        return (update(dBMessages)..where((tbl) => tbl.messageId.equals(messageId)))
            .write(new DBMessagesCompanion(deliveredTo: Value(jsonEncode(dec))));
      } else {
        print("no new content from dht for msg: " + jsonEncode(dec) + " " + text);
      }

      return null;
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

      return into(dBMessages).insert(entry);
    }
  }
}
