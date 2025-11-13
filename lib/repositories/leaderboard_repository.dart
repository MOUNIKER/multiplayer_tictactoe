import '../services/realtime_db_service.dart';

class LeaderboardRepository {
  final RealtimeDbService _db;
  LeaderboardRepository(this._db);

  Stream<List<Map<String, dynamic>>> leaderboardStream() {
    return _db.scoresStream();
  }
}
