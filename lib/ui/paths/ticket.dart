import 'package:mivent/utilities/extenions.dart';
import 'package:mivent/theme/colors.dart';
import 'package:flutter/material.dart';

class PaintShadow {
  const PaintShadow({
    this.color = Colors.black,
    this.offset = Offset.zero,
    this.elevation = 12,
    this.isPathTransparent = false,
  });
  final Color color;
  final Offset offset;
  final double elevation;
  final bool isPathTransparent;
}

class TicketPainter extends CustomPainter {
  TicketPainter({
    required this.topColor,
    required this.bodyColor,
    this.shadow,
    this.cuts = 4,
  }) : super();

  final int cuts;
  final PaintShadow? shadow;
  final Color topColor, bodyColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rad = size.width * 0.12;
    final ticketTopHeight = size.height * 0.2;
    final outlinePath = Path(), cutoutPath = Path();
    final fillPaint = Paint(),
        strokePaint = Paint()..style = PaintingStyle.stroke;

    outlinePath
      ..moveTo(0, size.height)
      ..lineTo(0, rad)
      ..arcToPoint(
        Offset(rad, 0),
        radius: Radius.circular(rad),
        clockwise: false,
      )
      ..lineTo(size.width - rad, 0)
      ..arcToPoint(
        Offset(size.width, rad),
        radius: Radius.circular(rad),
        clockwise: false,
      )
      ..lineTo(size.width, ticketTopHeight)
      ..arcToPoint(
        Offset(size.width, ticketTopHeight + rad),
        radius: Radius.circular(rad * 0.5),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - rad)
      ..arcToPoint(
        Offset(size.width - rad, size.height),
        radius: Radius.circular(rad),
        clockwise: false,
      )
      ..lineTo(rad, size.height)
      ..arcToPoint(
        Offset(0, size.height - rad),
        radius: Radius.circular(rad),
        clockwise: false,
      )
      ..lineTo(0, ticketTopHeight + rad)
      ..arcToPoint(
        Offset(0, ticketTopHeight),
        radius: Radius.circular(rad * 0.5),
        clockwise: false,
      )
      ..close();

    cutoutPath
      ..drawCuts(
        size.width - rad,
        Offset(rad * 0.5, 0),
        cuts,
        size: Size(rad * 0.7, rad * 0.75),
      )
      ..drawCuts(
        size.width - rad * 0.5,
        Offset(rad * 0.25, ticketTopHeight + rad * 0.5),
        7,
        size: Size(rad * 0.4, rad * 0.2),
      )
      ..drawCuts(
        size.width - rad,
        Offset(rad * 0.5, size.height),
        cuts,
        size: Size(rad * 0.7, rad * 0.75),
      );

    var ticketPath =
        Path.combine(PathOperation.difference, outlinePath, cutoutPath);

    if (shadow != null) {
      canvas
        ..save()
        ..translate(shadow!.offset.dx, shadow!.offset.dy)
        ..drawShadow(ticketPath, shadow!.color, shadow!.elevation,
            shadow!.isPathTransparent)
        ..restore();
    }

    canvas
      ..drawPath(
        ticketPath,
        strokePaint
          ..color = Color.lerp(topColor, bodyColor, 0.4)!
          ..strokeWidth = 4,
      )
      ..clipPath(ticketPath)
      ..drawRect(Rect.fromLTRB(0, 0, size.width, ticketTopHeight + rad * 0.5),
          fillPaint..color = topColor)
      ..drawRect(
          Rect.fromLTRB(
              0, ticketTopHeight + rad * 0.5, size.width, size.height),
          fillPaint..color = bodyColor)
      ..drawCircle(
        Offset(12, size.height * 0.1),
        size.width * 0.3,
        fillPaint..color = ColorPalette.pink,
      )
      ..drawCircle(
        Offset(size.width * 0.35, size.height),
        size.width * 0.4,
        fillPaint..color = Colors.blue,
      )
      ..drawCircle(
        Offset(size.width * 0.8, size.height * 0.45),
        size.width * 0.26,
        strokePaint
          ..color = ColorPalette.greyed[50]!
          ..strokeWidth = 4,
      )
      ..drawLine(
        const Offset(0.1, 0.4).scaleSize(size),
        const Offset(0.1, 0.5).scaleSize(size),
        fillPaint
          ..color = Colors.blue
          ..strokeWidth = 8,
      )
      ..drawLine(
        const Offset(0.8, 0.7).scaleSize(size),
        const Offset(0.8, 0.9).scaleSize(size),
        fillPaint
          ..color = ColorPalette.pink
          ..strokeWidth = 8,
      );

  }

  @override
  bool shouldRepaint(covariant TicketPainter oldDelegate) => false;
}
