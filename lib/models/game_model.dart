import 'package:equatable/equatable.dart';

enum CellValue { empty, X, O }

class GameModel extends Equatable {
  final List<CellValue> board; // length 9
  final String roomId;
  final String playerX; // uid
  final String playerO; // uid
  final String currentTurn; // uid of current player
  final bool finished;
  final String? winner; // uid or 'draw'

  const GameModel({
    required this.board,
    required this.roomId,
    required this.playerX,
    required this.playerO,
    required this.currentTurn,
    this.finished = false,
    this.winner,
  });

  factory GameModel.newGame({required String roomId, required String playerX, required String playerO}) {
    return GameModel(
      board: List.filled(9, CellValue.empty),
      roomId: roomId,
      playerX: playerX,
      playerO: playerO,
      currentTurn: playerX,
      finished: false,
      winner: null,
    );
  }

  GameModel copyWith({
    List<CellValue>? board,
    String? currentTurn,
    bool? finished,
    String? winner,
  }) {
    return GameModel(
      board: board ?? this.board,
      roomId: roomId,
      playerX: playerX,
      playerO: playerO,
      currentTurn: currentTurn ?? this.currentTurn,
      finished: finished ?? this.finished,
      winner: winner ?? this.winner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'board': board.map((c) => c.index).toList(),
      'roomId': roomId,
      'playerX': playerX,
      'playerO': playerO,
      'currentTurn': currentTurn,
      'finished': finished,
      'winner': winner,
    };
  }

  factory GameModel.fromMap(Map<dynamic, dynamic> map) {
    final boardList = (map['board'] as List<dynamic>).map((i) {
      final idx = i as int;
      return CellValue.values[idx];
    }).toList(growable: false);

    return GameModel(
      board: boardList,
      roomId: map['roomId'] as String,
      playerX: map['playerX'] as String,
      playerO: map['playerO'] as String,
      currentTurn: map['currentTurn'] as String,
      finished: map['finished'] as bool,
      winner: map['winner'] as String?,
    );
  }

  @override
  List<Object?> get props => [board, roomId, playerX, playerO, currentTurn, finished, winner];
}
