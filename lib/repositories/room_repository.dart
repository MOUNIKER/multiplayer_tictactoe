import '../models/room_model.dart';
import '../services/realtime_db_service.dart';
import '../models/game_model.dart';

class RoomRepository {
  final RealtimeDbService _db;
  RoomRepository(this._db);

  Future<void> createRoom(RoomModel r) => _db.createRoom(r);
  Future<void> joinRoom(String roomId, String guestUid) => _db.joinRoom(roomId, guestUid);
  Stream<RoomModel?> roomStream(String roomId) => _db.roomStream(roomId);
  Future<List<RoomModel>> fetchOpenRooms() => _db.fetchOpenRooms();
  Future<void> pushGameState(GameModel model) => _db.pushGameState(model);
  Stream<GameModel?> gameStream(String roomId) => _db.gameStream(roomId);
}
