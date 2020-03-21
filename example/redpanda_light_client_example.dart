import 'dart:async';

import 'package:redpanda_light_client/export.dart';
import 'dart:io';

void main() async {
  String dataFolderPath = 'data';

  /**
   * Create data folder for sqlite db.
   */
  await new Directory(dataFolderPath).create(recursive: true);

  await RedPandaLightClient.init(dataFolderPath, 5500);

  const oneSec = const Duration(days: 365 * 10);
  new Timer(oneSec, () => RedPandaLightClient.shutdown());

}

//todo documentation of used licenses
/**
 * sqlite for windows: https://www.sqlite.org/copyright.html
 * moor: MIT License: https://github.com/simolus3/moor/blob/master/LICENSE
 * asn1lib: BSD3: https://github.com/wstrange/asn1lib/blob/master/LICENSE
 */
