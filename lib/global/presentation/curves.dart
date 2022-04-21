import 'dart:math';

import 'package:flutter/material.dart';

class JumpCurve extends Curve {
  final double multiplier;
  final double offset;

  const JumpCurve({this.offset = 1, this.multiplier = 0.5});

  @override
  double transformInternal(double t) => offset + (sin(t * pi) * multiplier);
}
