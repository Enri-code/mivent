//#32BDF2, #F7528E, #4A9B09, #9D59A2, #FFE465

import 'package:flutter/material.dart';

abstract class ColorPalette {

  static MaterialColor pink = MaterialColor(0xFFE465FF, {
    500: Color(0xFFE465FF),
  });

  static MaterialColor purple = MaterialColor(0xFF6B13A5, {
    500: Color(0xFF591686),
  });

  static MaterialColor greyed = MaterialColor(0xFF364549, {
    50: Color(0xFFF0F0F0),
    200: Color(0xFF526166),
    500: Color(0xFF364549),
  });
}
