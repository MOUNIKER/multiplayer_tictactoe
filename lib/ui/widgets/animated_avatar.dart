import 'package:flutter/material.dart';

class AnimatedAvatar extends StatefulWidget {
  final String? imageUrl;
  final String initials;
  const AnimatedAvatar({Key? key, this.imageUrl, required this.initials}) : super(key: key);

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: CircleAvatar(
        radius: 22,
        backgroundImage: widget.imageUrl != null ? NetworkImage(widget.imageUrl!) : null,
        child: widget.imageUrl == null ? Text(widget.initials) : null,
      ),
    );
  }
}
