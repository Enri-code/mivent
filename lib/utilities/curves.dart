import 'dart:math';

import 'package:flutter/material.dart';

class JumpCurve extends Curve {
  final double multiplier;

  const JumpCurve([this.multiplier = 0.5]);

  @override
  double transformInternal(double t) => 1 + (sin(t * pi) * multiplier);
}
