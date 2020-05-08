// we define a data class to contain both a todo entry and the associated Friend
import 'package:redpanda_light_client/src/main/store/moor_database.dart';

class DBMessageWithFriend {
  DBMessageWithFriend(this.message, this.friend, this.fromMe);

  final DBMessage message;
  final DBFriend friend;
  final bool fromMe;
}
