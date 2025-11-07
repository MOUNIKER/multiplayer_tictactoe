import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/game_model.dart';
import '../models/room_model.dart';
import '../core/utils/constants.dart';

class RealtimeDbService {
  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://multiplayer-tictactoe-c4744-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  DatabaseReference roomsRef() => _db.ref(DBPaths.rooms);
  DatabaseReference gameRef(String roomId) =>
      _db.ref('${DBPaths.rooms}/$roomId/game');
  DatabaseReference roomRef(String roomId) =>
      _db.ref('${DBPaths.rooms}/$roomId');

  Future<void> createRoom(RoomModel room) async {
    await roomsRef().child(room.roomId).set(room.toMap());
  }

  Future<void> joinRoom(String roomId, String guestUid) async {
    await roomRef(roomId).update({'guestUid': guestUid, 'isOpen': false});
  }

  Stream<RoomModel?> roomStream(String roomId) {
    return roomRef(roomId).onValue.map((event) {
      final val = event.snapshot.value;
      if (val == null) return null;
      return RoomModel.fromMap(Map<dynamic, dynamic>.from(val as Map));
    });
  }

  Future<void> pushGameState(GameModel model) async {
    await gameRef(model.roomId).set(model.toMap());
  }

  Stream<GameModel?> gameStream(String roomId) {
    return gameRef(roomId).onValue.map((event) {
      final val = event.snapshot.value;
      if (val == null) return null;
      return GameModel.fromMap(Map<dynamic, dynamic>.from(val as Map));
    });
  }

  Future<List<RoomModel>> fetchOpenRooms() async {
    final snap = await roomsRef().orderByChild('isOpen').equalTo(true).get();
    if (!snap.exists) return [];
    final items = <RoomModel>[];
    for (final child in snap.children) {
      items.add(
        RoomModel.fromMap(Map<dynamic, dynamic>.from(child.value as Map)),
      );
    }
    return items;
  }

  Future<void> setScore(String uid, Map<String, dynamic> data) async {
    await _db.ref('${DBPaths.scores}/$uid').update(data);
  }

  Future<Map<String, dynamic>?> getScore(String uid) async {
    final snap = await _db.ref('${DBPaths.scores}/$uid').get();
    if (!snap.exists) return null;
    return Map<String, dynamic>.from(snap.value as Map);
  }

  Future<List<Map<String, dynamic>>> fetchLeaders({int limit = 20}) async {
    final snap = await _db
        .ref(DBPaths.scores)
        .orderByChild('total')
        .limitToLast(limit)
        .get();

    if (!snap.exists) return [];

    final out = <Map<String, dynamic>>[];

    for (final c in snap.children) {
      final map = Map<String, dynamic>.from(c.value as Map);
      map['uid'] = c.key; // Include UID for identification

      // Defaults
      final wins = map['wins'] as int? ?? 0;
      final draws = map['draws'] as int? ?? 0;
      map['total'] = wins;
      map['displayName'] = map['displayName'] ?? 'Anonymous';

      out.add(map);
    }

    // Sort high → low
    out.sort((a, b) => (b['total'] as int).compareTo(a['total'] as int));

    return out;
  }

  Stream<List<Map<String, dynamic>>> scoresStream() {
    return _db.ref(DBPaths.scores).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final out = <Map<String, dynamic>>[];
      final map = Map<dynamic, dynamic>.from(data as Map);

      map.forEach((key, value) {
        final user = Map<String, dynamic>.from(value as Map);
        user['uid'] = key;
        final wins = user['wins'] as int? ?? 0;
        user['total'] = wins; // only wins count
        user['displayName'] = user['displayName'] ?? 'Anonymous';
        out.add(user);
      });

      out.sort((a, b) => (b['total'] as int).compareTo(a['total'] as int));
      return out;
    });
  }
}
