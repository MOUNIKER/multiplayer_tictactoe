import 'package:flutter/material.dart';
import '../../models/game_model.dart';

class CellWidget extends StatefulWidget {
  final CellValue value;
  const CellWidget({Key? key, required this.value}) : super(key: key);

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    if (widget.value != CellValue.empty) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == CellValue.empty && widget.value != CellValue.empty) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSymbol() {
    switch (widget.value) {
      case CellValue.X:
        return Text('X', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold));
      case CellValue.O:
        return Text('O', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold));
      case CellValue.empty:
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        final scale = Curves.elasticOut.transform(_controller.value);
        return Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(border: Border.all(color: Colors.black26), color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Transform.scale(scale: scale, child: _buildSymbol())),
        );
      },
    );
  }
}
