import 'package:flutter/material.dart';
import '../../models/game_model.dart';
import 'cell_widget.dart';

class GameBoard extends StatelessWidget {
  final List<CellValue> board;
  final bool enabled;
  final void Function(int) onCellTap;
  const GameBoard({super.key, required this.board, required this.enabled, required this.onCellTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 320,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: enabled && board[i] == CellValue.empty ? () => onCellTap(i) : null,
            child: CellWidget(value: board[i]),
          );
        },
      ),
    );
  }
}
