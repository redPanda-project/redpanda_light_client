import 'package:redpanda_light_client/export.dart';
import 'dart:io';

main() async {
  String dataFolderPath = 'data';

  /**
   * Create data folder for sqlite db.
   */
  await new Directory(dataFolderPath).create(recursive: true);

  RedPandaLightClient.init(dataFolderPath);
}

//todo documentation of used licenses
/**
 * sqlite for windows: https://www.sqlite.org/copyright.html
 * moor: MIT License https://github.com/simolus3/moor/blob/master/LICENSE
 */
