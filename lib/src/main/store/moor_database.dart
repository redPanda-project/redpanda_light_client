import 'package:moor/moor.dart';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'LocalSettings.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class LocalSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 6, max: 32)();

  TextColumn get content => text().named('body')();

  IntColumn get category => integer().nullable()();

  BlobColumn get kademliaId => blob()();
}


