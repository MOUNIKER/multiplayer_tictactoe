import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/leaderboard_repository.dart';

class LeaderboardViewModel extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final LeaderboardRepository _repo;
  LeaderboardViewModel(this._repo) : super(const AsyncValue.loading()) {
    fetchTop();
  }

  Future<void> fetchTop({int limit = 20}) async {
    try {
      final list = await _repo.fetchTopLeaders(limit);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
