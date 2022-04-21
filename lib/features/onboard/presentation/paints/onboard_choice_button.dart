import 'package:flutter/material.dart';

class OnboardChoiceButton extends CustomPainter {
  const OnboardChoiceButton([this.fillColor = Colors.transparent]);
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    var edgeInset = 12.0;
    final path = Path();
    final paint = Paint()
      ..color = fillColor
      ..strokeWidth = 4;

    path
      ..moveTo(size.width + size.height * 0.5, 0)
      ..lineTo(size.width - size.height * 0.5, size.height)
      /*
      ..lineTo(0, size.height - edgeInset)
      ..lineTo(0, edgeInset)
      ..lineTo(edgeInset, 0) */

      ..lineTo(edgeInset, size.height)
      ..arcToPoint(Offset(0, size.height - edgeInset),
          radius: Radius.circular(edgeInset + 4), clockwise: false)
      //..lineTo(0, size.height - edgeInset)
      ..lineTo(0, edgeInset)
      ..arcToPoint(Offset(edgeInset, 0),
          radius: Radius.circular(edgeInset + 4), clockwise: false)
      //..lineTo(edgeInset, 0)
      ..close();

    canvas
      ..drawPath(path, paint)
      ..drawPath(
          path,
          paint
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5)
      ..drawPath(
          path,
          paint
            ..color = const Color(0xFFD4D4D4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
