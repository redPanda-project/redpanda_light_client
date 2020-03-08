// TODO: Put public facing types in this file.

import 'package:redpanda_light_client/src/main/Channel.dart';
import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';

/// Checks if you are awesome. Spoiler: you are.
class RedPandaLightClient {
  static List<Channel> _channels;
  static String test = "test";

  static init(KademliaId myKademliaId) {
    ConnectionService connectionService = ConnectionService(myKademliaId);
    connectionService.start();
  }

  static List<Channel> getChannels() {
    if (_channels == null) {
      _channels = new List<Channel>();
      _channels.add(new Channel("Name 1"));
      _channels.add(new Channel("Name 2"));
    }

    return _channels;
  }
}
