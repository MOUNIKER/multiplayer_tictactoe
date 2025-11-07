import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/leaderboard_repository.dart';

class LeaderboardViewModel extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final LeaderboardRepository _repo;
  StreamSubscription? _sub;

  LeaderboardViewModel(this._repo) : super(const AsyncValue.loading()) {
    _listenLeaderboard();
  }

  void _listenLeaderboard() {
    _sub = _repo.leaderboardStream().listen((data) {
      state = AsyncValue.data(data);
    }, onError: (e, st) {
      state = AsyncValue.error(e, st);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
