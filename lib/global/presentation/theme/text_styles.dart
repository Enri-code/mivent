import 'package:flutter/material.dart';

abstract class TextStyles {
  static const big1 = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
  );
  static const big2 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );
  static const header1 = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );
  static const header2 = TextStyle(
    fontSize: 27.5,
    fontWeight: FontWeight.w500,
  );
  static const header3 = TextStyle(
    fontSize: 24.5,
    fontWeight: FontWeight.w500,
  );
  static const header4 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static const subHeader1 = TextStyle(
    fontSize: 19.5,
    fontWeight: FontWeight.w500,
  );
  static const subHeader2 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  static const hint1 = TextStyle(color: Colors.black54);
}

abstract class FontFamily {
  static const lucette = 'Lucette';
}
