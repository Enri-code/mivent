import 'package:flutter/material.dart';
import 'package:mivent/core/utils/extensions/path_draw_cuts.dart';

_verticalTicketPath(Size size,
    {stubRatio = 0.8, edgeCurveRadius = 16, addCuts = true}) {
  final path = Path();
  final stubHeight = size.height * stubRatio;

  path
    ..moveTo(0, edgeCurveRadius)
    ..arcToPoint(
      Offset(edgeCurveRadius, 0),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..lineTo(size.width - edgeCurveRadius, 0)
    ..arcToPoint(
      Offset(size.width, edgeCurveRadius),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..lineTo(size.width, stubHeight)
    ..arcToPoint(
      Offset(size.width, stubHeight + edgeCurveRadius),
      radius: Radius.circular(edgeCurveRadius * 0.5),
      clockwise: false,
    )
    ..lineTo(size.width, size.height - edgeCurveRadius)
    ..arcToPoint(
      Offset(size.width - edgeCurveRadius, size.height),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..lineTo(edgeCurveRadius, size.height)
    ..arcToPoint(
      Offset(0, size.height - edgeCurveRadius),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..lineTo(0, stubHeight + edgeCurveRadius)
    ..arcToPoint(
      Offset(0, stubHeight),
      radius: Radius.circular(edgeCurveRadius * 0.5),
      clockwise: false,
    )
    ..close();

  if (addCuts) {
    return Path.combine(
      PathOperation.difference,
      path,
      Path()
        ..drawCuts(
          size.width - edgeCurveRadius * 0.5,
          Offset(edgeCurveRadius * 0.25, stubHeight + edgeCurveRadius * 0.5),
          9,
          size: Size(edgeCurveRadius * 0.5, edgeCurveRadius * 0.2),
        ),
    );
  }
  return path;
}

_horizontalTicketPath(Size size,
    {stubRatio = 0.8, edgeCurveRadius = 16, addCuts = true}) {
  final path = Path();
  path
    ..moveTo(edgeCurveRadius, 0)
    ..lineTo(size.width * stubRatio - edgeCurveRadius, 0)
    ..relativeArcToPoint(Offset(edgeCurveRadius, 0),
        radius: Radius.circular(edgeCurveRadius * 0.5), clockwise: false)
    ..lineTo(size.width - edgeCurveRadius, 0)
    ..arcToPoint(
      Offset(size.width, edgeCurveRadius),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..lineTo(size.width, size.height - edgeCurveRadius)
    ..arcToPoint(
      Offset(size.width - edgeCurveRadius, size.height),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..lineTo(size.width * stubRatio, size.height)
    ..relativeArcToPoint(Offset(-edgeCurveRadius, 0),
        radius: Radius.circular(edgeCurveRadius * 0.5), clockwise: false)
    ..lineTo(edgeCurveRadius, size.height)
    ..arcToPoint(
      Offset(0, size.height - edgeCurveRadius),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..lineTo(0, edgeCurveRadius)
    ..arcToPoint(
      Offset(edgeCurveRadius, 0),
      radius: Radius.circular(edgeCurveRadius),
      clockwise: false,
    )
    ..close();

  if (addCuts) {
    return Path.combine(
      PathOperation.difference,
      path,
      Path()
        ..drawCuts(
          size.height,
          Offset(size.width * stubRatio - edgeCurveRadius * 0.5, 0),
          8,
          size: const Size(4, 8),
          direction: Axis.vertical,
        ),
    );
  }
  return path;
}

class TicketClipper extends CustomClipper<Path> {
  TicketClipper(
      {this.direction = Axis.vertical,
      this.stubRatio = 0.79,
      this.edgeCurveRadius = 16})
      : super();

  ///Position of the cutout part, relative to height of ticket.
  ///
  ///Clamped between 0.1 and 0.9
  final Axis direction;
  final double stubRatio;
  final double edgeCurveRadius;

  @override
  Path getClip(Size size) => direction == Axis.horizontal
      ? _horizontalTicketPath(size,
          stubRatio: stubRatio, edgeCurveRadius: edgeCurveRadius)
      : _verticalTicketPath(
          size,
          stubRatio: stubRatio,
          edgeCurveRadius: edgeCurveRadius,
        );

  @override
  bool shouldReclip(covariant TicketClipper oldClipper) => true;
}

class TicketPainter extends CustomPainter {
  TicketPainter(
      {this.direction = Axis.vertical,
      this.stubRatio = 0.79,
      this.outlineColor = Colors.white,
      this.edgeCurveRadius = 16})
      : super();

  ///Relaive position of the cutout part, to its height.
  final double stubRatio;
  final Color outlineColor;
  final Axis direction;
  final double edgeCurveRadius;

  @override
  paint(Canvas canvas, Size size) {
    var path = direction == Axis.horizontal
        ? _horizontalTicketPath(
            size,
            stubRatio: stubRatio,
            edgeCurveRadius: edgeCurveRadius,
            addCuts: false,
          )
        : _verticalTicketPath(
            size,
            stubRatio: stubRatio,
            edgeCurveRadius: edgeCurveRadius,
            addCuts: false,
          );

    canvas
      ..save()
      ..translate(0, -8)
      ..drawShadow(path, Colors.black, 24, false)
      ..drawShadow(path, Colors.black54, 24, false)
      ..restore();

    canvas
      ..drawPath(
        path,
        Paint()
          ..strokeWidth = 15
          ..color = Colors.grey[900]!
          ..style = PaintingStyle.stroke,
      )
      ..drawPath(
        path,
        Paint()
          ..strokeWidth = 12
          ..color = outlineColor
          ..style = PaintingStyle.stroke,
      )
      ..drawPath(
        path,
        Paint()
          ..strokeWidth = 1.5
          ..color = Colors.black
          ..style = PaintingStyle.stroke,
      );
  }

  @override
  bool shouldRepaint(covariant TicketPainter oldDelegate) => true;
}
