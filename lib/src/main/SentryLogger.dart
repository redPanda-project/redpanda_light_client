import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:sentry/sentry.dart';

class SentryLogger {
  static void log(String message) {
    ConnectionService.sentry.captureEvent(new SentryEvent(environment: "dart", message: new Message(message)));
  }
}
