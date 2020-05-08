import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/store/DBFriends.dart';

part 'DBFriendsDao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [DBFriends])
class DBFriendsDao extends DatabaseAccessor<AppDatabase> with _$DBFriendsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  DBFriendsDao(AppDatabase db) : super(db);

  Future<int> addFriend(int id, String name) {
    DBFriendsCompanion entry = DBFriendsCompanion.insert(id: id, name: Value(name));

    return into(dBFriends).insert(entry);
  }

  Future<DBFriend> getFriend(int id) {
    return (select(dBFriends)
      ..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<bool> updateFriend(int id, String name) async {
    var friend = await getFriend(id);

    if (friend != null && friend.name == name) {
//      print("name did not change");
      return false;
    }

    if (friend == null) {
      await addFriend(id, name);
    } else {
      var newFriend = friend.copyWith(name: name);
      await (update(dBFriends)
        ..where((tbl) => tbl.id.equals(id))).write(newFriend);
    }
    return true;
  }
}
