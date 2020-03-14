import 'dart:typed_data';

import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/commands/FBPeerList_im.redpanda.commands_generated.dart';
import 'package:test/test.dart';

void main() {
  group('FlatBuffer tests', () {
    setUp(() {});

    test('Test bytes to PeerList', () {
      // bytes for flatbuffer peerlist with 5 peers, first KademliaId: 2PCbqVfWuXK2t9g7YrPcTajYSZA2
      Uint8List bytesForFlatBufferPeerList = Utils.hexDecode(
          "0c000000000006000800040006000000040000000500000038010000e8000000940000004c0000000400000032ffffff2800000008000000040000001600000072616e645f6477687267667765725f74657374697034000014000000db9c8809b856cdb3fc20bf2bb9821104e9d10b5076ffffff2800000008000000030000001600000072616e645f6477687267667765725f74657374697033000014000000e02a8e882839fc04c936e680eda435b60f409020baffffff2800000008000000020000001600000072616e645f6477687267667765725f746573746970320000140000007769ae09f302c8412444abb15e500c3fae5387ba00000a001000040008000c000a0000002800000008000000010000001600000072616e645f6477687267667765725f74657374697031000014000000d8a9689b6c8a1b86c1a1e1bf8c095c7d03274c4508000c00040008000800000024000000040000001600000072616e645f6477687267667765725f746573746970300000140000006340b9c218ee09dc758756cfe819ca0cdbc30fe3");

      FBPeerList fbPeerList = new FBPeerList(bytesForFlatBufferPeerList);
      expect(fbPeerList.peers.length, 5);

      for (var i = 0; i < 5; i++) {
        expect(fbPeerList.peers[i].ip, "rand_dwhrgfwer_testip" + i.toString());
        expect(fbPeerList.peers[i].port, i);
      }

      KademliaId kademliaId =
          KademliaId.fromBytes(Uint8List.fromList(fbPeerList.peers[0].nodeId));

      expect(kademliaId.toString(), "2PCbqVfWuXK2t9g7YrPcTajYSZA2");
    });
  });
}
