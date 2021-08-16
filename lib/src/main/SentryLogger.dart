import 'package:redpanda_light_client/src/main/ConnectionService.dart';
import 'package:sentry/sentry.dart';

class SentryLogger {
  static void log(String message) {
    ConnectionService.sentry.captureMessage(message);
  }
}
