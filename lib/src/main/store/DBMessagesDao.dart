import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/store/DBMessages.dart';

part 'DBMessagesDao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [DBMessages])
class DBMessagesDao extends DatabaseAccessor<AppDatabase> with _$DBMessagesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  DBMessagesDao(AppDatabase db) : super(db);

  // watches all Messages for a given channel id. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<List<DBMessage>> watchDBChannelEntries(int channelId) {
    return (select(dBMessages)..where((tbl) => tbl.id.equals(channelId))).watch();
  }
}
