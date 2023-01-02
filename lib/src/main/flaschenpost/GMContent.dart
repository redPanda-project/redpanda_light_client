import 'package:drift/drift.dart';

import 'GMType.dart';

abstract class GMContent {
  Uint8List? _content;

  GMContent(this._content);

  void computeContent();

  GMType getGMType();

  Uint8List? get content {
    if (_content == null) {
      computeContent();
    }
    return _content;
  }

  set content(Uint8List? value) {
    _content = value;
  }
}
