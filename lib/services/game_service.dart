import 'package:uuid/uuid.dart';
import '../models/game_model.dart';

class GameService {
  static const winningLines = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6],
  ];

  String createRoomId() => const Uuid().v4();

  GameModel applyMove(GameModel model, int index) {
    if (model.finished) return model;
    if (model.board[index] != CellValue.empty) return model;

    final isX = model.currentTurn == model.playerX;
    final mark = isX ? CellValue.X : CellValue.O;
    final newBoard = List<CellValue>.from(model.board);
    newBoard[index] = mark;

    final nextTurn = (model.currentTurn == model.playerX) ? model.playerO : model.playerX;
    final after = model.copyWith(board: newBoard, currentTurn: nextTurn);

    // check winner
    final winner = _checkWinner(newBoard);
    if (winner != null) {
      return after.copyWith(finished: true, winner: winner);
    }

    final draw = !newBoard.contains(CellValue.empty);
    if (draw) {
      return after.copyWith(finished: true, winner: 'draw');
    }

    return after;
  }

  String? _checkWinner(List<CellValue> board) {
    for (final line in winningLines) {
      final a = board[line[0]], b = board[line[1]], c = board[line[2]];
      if (a != CellValue.empty && a == b && b == c) {
        // determine owner
        return a == CellValue.X ? 'X' : 'O';
      }
    }
    return null;
  }
}
