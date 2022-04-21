import 'package:flutter/widgets.dart';

extension PathExt on Path {
  drawCuts(double length, Offset off, int cuts,
      {Size size = const Size.square(8), Axis direction = Axis.horizontal}) {
    var cutDis = length / (cuts + 1);

    for (var i = 1; i <= cuts; i++) {
      var pos = direction == Axis.horizontal
          ? Offset(cutDis * i, 0)
          : Offset(0, cutDis * i);
      addOval(Rect.fromCenter(
          center: pos + off, height: size.height, width: size.width));
    }
  }
}
