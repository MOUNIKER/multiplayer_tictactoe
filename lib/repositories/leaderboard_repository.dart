import '../services/realtime_db_service.dart';

class LeaderboardRepository {
  final RealtimeDbService _db;
  LeaderboardRepository(this._db);

  Future<List<Map<String, dynamic>>> fetchTopLeaders(int limit) => _db.fetchLeaders(limit: limit);
}
