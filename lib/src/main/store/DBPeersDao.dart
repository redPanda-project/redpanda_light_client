import 'package:moor/moor.dart';
import 'package:redpanda_light_client/export.dart';
import 'package:redpanda_light_client/src/main/KademliaId.dart';
import 'package:redpanda_light_client/src/main/Utils.dart';
import 'package:redpanda_light_client/src/main/store/DBPeers.dart';

part 'DBPeersDao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [DBPeers])
class DBPeersDao extends DatabaseAccessor<AppDatabase> with _$DBPeersDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  DBPeersDao(AppDatabase db) : super(db);

  /**
   * Returns the id of the new Peer in db.
   */
  Future<int> insertNewPeer(String ip, int port, KademliaId kademliaId, {Uint8List publicKey}) async {
    DBPeersCompanion entry = DBPeersCompanion.insert(
        ip: ip,
        port: port,
        knownSince: Utils.getCurrentTimeMillis(),
        kademliaId: kademliaId.bytes,
        publicKey: Value(publicKey));
    return into(dBPeers).insert(entry);
  }

  Future<List<DBPeer>> getAllPeers() {
    return select(dBPeers).get();
  }

  Future<int> updatePeer(int peerId, String ip, int port, int score) async {
    DBPeersCompanion entry = DBPeersCompanion.insert(
      ip: ip,
      port: port,
      score: Value(score),
    );
    return (update(dBPeers)..where((tbl) => tbl.id.equals(peerId))).write(entry);
  }

  Future<DBPeer> getPeerByKademliaId(KademliaId kademliaId) {
    return (select(dBPeers)..where((tbl) => tbl.kademliaId.equals(kademliaId.bytes))).getSingle();
  }

  Future<int> removePeerByKademliaId(KademliaId kademliaId) {
    return (delete(dBPeers)..where((tbl) => tbl.kademliaId.equals(kademliaId.bytes))).go();
  }
}
