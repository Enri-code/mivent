import 'package:flutter/material.dart';

extension PathExt on Path {
  drawCuts(double width, Offset off, int cuts,
      {Size size = const Size.square(1)}) {
    var cutDis = width / (cuts + 1);
    for (var i = 1; i <= cuts; i++) {
      addOval(Rect.fromCenter(
        center: Offset(off.dx + cutDis * i, off.dy),
        height: size.height,
        width: size.width,
      ));
    }
  }
}

extension OffsetExt on Offset {
  //Offset scaleOff(Offset scaler) => Offset(dx * scaler.dx, dy * scaler.dy);
  Offset scaleSize(Size scaler) =>
      Offset(dx * scaler.width, dy * scaler.height);
}
