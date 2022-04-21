//#32BDF2, #F7528E, #4A9B09, #9D59A2, #FFE465

import 'package:flutter/material.dart';

abstract class ColorPalette {
  static const Color secondaryColor = Colors.blueGrey,
      appBarColor = Color.fromARGB(150, 155, 81, 224),
      favouriteColor = Colors.red;

  static const MaterialColor pink = MaterialColor(0xFFF361FB, {
    500: Color(0xFFF361FB),
  });
  static const MaterialColor orange = MaterialColor(0xFFFC7B51, {
    500: Color(0xFFFC7B51),
  });
  static const MaterialColor primary = MaterialColor(0xFF9B51E0, {
    500: Color(0xFF9B51E0),
  });

  static const MaterialColor greyed = MaterialColor(0xFF364549, {
    50: Color(0xFFF0F0F0),
    100: Color(0xFFbdb3b3),
    200: Color(0xFF526166),
    300: Color(0xFF526166),
    500: Color(0xFF364549),
  });
}
