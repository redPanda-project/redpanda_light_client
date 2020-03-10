import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:sentry/io_client.dart';

class SentryLogger {
  static void log(String message) {
    ConnectionService.sentry
        .capture(event: new Event(environment: "dart", message: message));
  }
}
