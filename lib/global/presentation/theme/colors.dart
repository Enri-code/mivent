//#32BDF2, #F7528E, #4A9B09, #9D59A2, #FFE465

import 'package:flutter/material.dart';

abstract class ColorPalette {
  static const Color secondaryColor = Color(0xFFFF9151), //Colors.blueGrey,
      appBarColor = Color(0x959B51E0),
      favouriteColor = Colors.red;

  static const MaterialColor pink = MaterialColor(0xFFF361FB, {
    500: Color(0xFFF361FB),
  });
  static const MaterialColor primary = MaterialColor(0xFFAC65F3, {
    500: Color(0xFF9B51E0),
  });
}
