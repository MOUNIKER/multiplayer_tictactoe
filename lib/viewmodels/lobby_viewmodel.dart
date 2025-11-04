import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/room_repository.dart';
import '../models/room_model.dart';
import '../services/game_service.dart';

class LobbyViewModel extends StateNotifier<AsyncValue<List<RoomModel>>> {
  final RoomRepository _repo;
  final GameService _gameService;
  LobbyViewModel(this._repo, this._gameService) : super(const AsyncValue.loading()) {
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _repo.fetchOpenRooms();
      state = AsyncValue.data(rooms);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<RoomModel> createRoom(String hostUid) async {
    final id = _gameService.createRoomId();
    final room = RoomModel(roomId: id, hostUid: hostUid, guestUid: null, isOpen: true);
    await _repo.createRoom(room);
    await _loadRooms();
    return room;
  }

  Future<void> joinRoom(String roomId, String guestUid) async {
    await _repo.joinRoom(roomId, guestUid);
    await _loadRooms();
  }

  Future<void> refresh() => _loadRooms();
}
