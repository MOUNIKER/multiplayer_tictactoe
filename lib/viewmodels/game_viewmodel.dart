import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/room_repository.dart';
import '../repositories/score_repository.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';

class GameViewModel extends StateNotifier<AsyncValue<GameModel?>> {
  final String roomId;
  final RoomRepository _repo;
  final ScoreRepository _scoreRepo;
  final GameService _gameService;
  StreamSubscription<GameModel?>? _sub;

  GameViewModel(this.roomId, this._repo, this._scoreRepo, this._gameService)
    : super(const AsyncValue.loading()) {
    _listen();
  }

  void _listen() {
    _sub = _repo
        .gameStream(roomId)
        .listen(
          (g) {
            state = AsyncValue.data(g);
          },
          onError: (e, st) {
            state = AsyncValue.error(e, st);
          },
        );
  }

  Future<void> createInitialGame(String playerX, String playerO) async {
    final gm = GameModel.newGame(
      roomId: roomId,
      playerX: playerX,
      playerO: playerO,
    );
    await _repo.pushGameState(gm);
    state = AsyncValue.data(gm);
  }

  Future<void> makeMove(String playerUid, int index) async {
    final cur = state.value;
    if (cur == null) return;
    if (cur.finished) return;
    if (cur.currentTurn != playerUid) return;

    final updated = _gameService.applyMove(cur, index);

    // if winner returned as 'X' or 'O', map to uid
    String? mappedWinner;
    if (updated.finished &&
        updated.winner != null &&
        updated.winner != 'draw') {
      mappedWinner = (updated.winner == 'X')
          ? updated.playerX
          : updated.playerO;
    } else if (updated.finished && updated.winner == 'draw') {
      mappedWinner = 'draw';
    }

    final finalState = updated.copyWith(winner: mappedWinner);
    await _repo.pushGameState(finalState);

    if (finalState.finished) {
      await _updateScores(finalState);
    }
  }

  Future<void> _updateScores(GameModel finalState) async {
    // simplistic scoring: win +1, loss 0, draw +0
    // fetch, update and write to DB via score repo
    if (finalState.winner == null) return;
    if (finalState.winner == 'draw') {
      // increment draws for both
      await _incrementDraw(finalState.playerX);
      await _incrementDraw(finalState.playerO);
    } else {
      final winner = finalState.winner!;
      final loser = (winner == finalState.playerX)
          ? finalState.playerO
          : finalState.playerX;
      await _incrementWin(winner);
      await _incrementLoss(loser);
    }
  }

  Future<void> _incrementLoss(String uid) async {
    final map = await _scoreRepo.getScore(uid) ?? {};
    final losses = (map['losses'] as int? ?? 0) + 1;
    final wins = map['wins'] as int? ?? 0;
    final draws = map['draws'] as int? ?? 0;

    await _scoreRepo.updateScore(uid, {
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'total': wins + draws,
    });
  }

  Future<void> _incrementWin(String uid) async {
    final map = await _scoreRepo.getScore(uid) ?? {};
    final wins = (map['wins'] as int? ?? 0) + 1;
    final losses = map['losses'] as int? ?? 0;
    final draws = map['draws'] as int? ?? 0;

    await _scoreRepo.updateScore(uid, {
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'total': wins + draws,
    });
  }

  Future<void> _incrementDraw(String uid) async {
    final map = await _scoreRepo.getScore(uid) ?? {};
    final draws = (map['draws'] as int? ?? 0) + 1;
    final wins = map['wins'] as int? ?? 0;
    final losses = map['losses'] as int? ?? 0;

    await _scoreRepo.updateScore(uid, {
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'total': wins + draws,
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}