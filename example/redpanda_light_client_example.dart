import 'dart:async';

import 'package:redpanda_light_client/export.dart';
import 'dart:io';

void main() async {
  String dataFolderPath = 'data';

  /**
   * Create data folder for sqlite db.
   */
  await new Directory(dataFolderPath).create(recursive: true);

  var watchDBChannelEntries = RedPandaLightClient.init(dataFolderPath, 5500);


  print('asd');

  const oneSec = const Duration(days: 365 * 10);
  new Timer(oneSec, () => RedPandaLightClient.shutdown());

//  var watchDBChannelEntries = RedPandaLightClient.watchDBChannelEntries();

  RedPandaLightClient.onNewMessage = onNewMessage;

  await for (var c in watchDBChannelEntries) {
    for (DBChannel dbc in c) {
//      var watchDBMessageEntries = RedPandaLightClient.watchDBMessageEntries(dbc.id);
//      watchDBMessageEntries.listen((event) { })
      print('waiting for messages for channel ${dbc.id}');
    }
    print(c);
  }
}

onNewMessage(DBMessageWithFriend msg, String channelName) {
  print('#########\n\nNew Message for Channel $channelName\n\n${msg.friend?.name}: ${msg.message.content}\n\n#########');
}

//todo documentation of used licenses
/**
 * sqlite for windows: https://www.sqlite.org/copyright.html
 * moor: MIT License: https://github.com/simolus3/moor/blob/master/LICENSE
 * asn1lib: BSD3: https://github.com/wstrange/asn1lib/blob/master/LICENSE
 */
