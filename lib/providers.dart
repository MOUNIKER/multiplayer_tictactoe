import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiplayer_tictactoe/models/app_user.dart';
import 'services/firebase_auth_service.dart';
import 'services/realtime_db_service.dart';
import 'services/game_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/room_repository.dart';
import 'repositories/score_repository.dart';
import 'repositories/leaderboard_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/lobby_viewmodel.dart';
import 'viewmodels/game_viewmodel.dart';
import 'viewmodels/leaderboard_viewmodel.dart';

// Services
final firebaseAuthServiceProvider = Provider((ref) => FirebaseAuthService());
final realtimeDbServiceProvider = Provider((ref) => RealtimeDbService());
final gameServiceProvider = Provider((ref) => GameService());

// Repositories
final authRepositoryProvider = Provider((ref) => AuthRepository(ref.read(firebaseAuthServiceProvider)));
final roomRepositoryProvider = Provider((ref) => RoomRepository(ref.read(realtimeDbServiceProvider)));
final scoreRepositoryProvider = Provider((ref) => ScoreRepository(ref.read(realtimeDbServiceProvider)));
final leaderboardRepositoryProvider = Provider((ref) => LeaderboardRepository(ref.read(realtimeDbServiceProvider)));


final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<AppUser?>>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});


final lobbyViewModelProvider = StateNotifierProvider<LobbyViewModel, AsyncValue<dynamic>>((ref) {
  return LobbyViewModel(ref.read(roomRepositoryProvider), ref.read(gameServiceProvider));
});

final gameViewModelProvider = StateNotifierProvider.family<GameViewModel, AsyncValue<dynamic>, String>((ref, roomId) {
  final roomRepo = ref.read(roomRepositoryProvider);
  final scoreRepo = ref.read(scoreRepositoryProvider);
  final gameSvc = ref.read(gameServiceProvider);
  return GameViewModel(roomId, roomRepo, scoreRepo, gameSvc);
});

final leaderboardViewModelProvider = StateNotifierProvider<LeaderboardViewModel, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return LeaderboardViewModel(ref.read(leaderboardRepositoryProvider));
});
