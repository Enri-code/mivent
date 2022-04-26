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
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );
  static const header2 = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.w500,
  );
  static const header3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  static const header4 = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w500,
  );
  static const subHeader1 = TextStyle(
    fontSize: 20,
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
