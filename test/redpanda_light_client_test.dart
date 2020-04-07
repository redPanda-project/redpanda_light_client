import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/store/DBMessagesDao.dart';
import 'package:test/test.dart';

AppDatabase appDatabase;

void main() {
  group('A group of tests', () {
    setUp(() async {
//      await RedPandaLightClient.initForDebug("data", 5800);
    });
//    RedPandaLightClient awesome;

    test('Test watch messages', () async {
      //todo test breaks the test_coverage, maybe fix this test again?

      var u = Utils.getCurrentTimeMillis();
      for (int i = 0; i < 10; i++) {
        new NodeId.withNewKeyPair();
      }
      print(Utils.getCurrentTimeMillis() - u);

//      await RedPandaLightClient.writeMessage(-1, "text");

//      print("asd");
//      var watchDBMessageEntries = RedPandaLightClient.watchDBMessageEntries(-1);
//      print("asd5345345");
//      print(watchDBMessageEntries);
//      print("asdf");

//     await RedPandaLightClient.writeMessage(-1, "text");

//      watchDBMessageEntries.listen((event) {
//        print(event);
//      });

      //wait 2 seconds for data to pass to listener
//      await new Future.delayed(const Duration(seconds: 2), () => "2");

//      await RedPandaLightClient.shutdown();

//      await for (List<DBMessageWithName> m in  watchDBMessageEntries.take(1)) {
//        print(m);
//        print("jsdhgfhjsdgfsdhjf");
//        watchDBMessageEntries.
//      }

//      List<DBMessageWithName> m = await watchDBMessageEntries.first;
//      print(m);
//      expect(m, []);
    });
  });
}
