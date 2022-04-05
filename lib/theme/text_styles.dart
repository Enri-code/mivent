import 'package:flutter/material.dart';

abstract class TextStyles {
  static const header1 = TextStyle(
    fontSize: 32,
    height: 1.1,
    fontWeight: FontWeight.bold,
  );
  static const header2 = TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
  static const header3 = TextStyle(fontSize: 23, fontWeight: FontWeight.w600);
  static const header4 = TextStyle(fontSize: 21, fontWeight: FontWeight.w700);
  static const body1 = TextStyle(fontSize: 17);
}

abstract class FontFamily {
  static const lucette = 'Lucette';
  static const chuckry = 'Chuckry';
}
