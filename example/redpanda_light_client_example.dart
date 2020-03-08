import 'package:redpanda_light_client/redpanda_light_client.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';

main() {
  var awesome = RedPandaLightClient();
  print('awesome: ${RedPandaLightClient.test}');

  RedPandaLightClient.init(new KademliaId());
}
