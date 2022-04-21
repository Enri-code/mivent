import 'package:flutter/material.dart';
import 'package:mivent/features/menu/presentation/painters/bubble.dart';

class BubblesWidget extends StatefulWidget {
  const BubblesWidget({Key? key}) : super(key: key);

  @override
  State<BubblesWidget> createState() => _BubblesWidgetState();
}

class _BubblesWidgetState extends State<BubblesWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, cons) => CustomPaint(
          painter: BubblesPainter(_controller, bubblesCount: 8),
          size: cons.biggest,
        ),
      );
}
