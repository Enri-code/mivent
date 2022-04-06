import 'package:flutter/material.dart';
import 'package:mivent/theme/colors.dart';

class ThemeSettings {
  static const appName = 'Mivent';

  static final myTextTheme =
      Typography.blackRedmond.apply(fontFamily: 'Lucette').copyWith(
            bodyText1: const TextStyle(
              fontSize: 16.5,
              height: 1.02,
              fontWeight: FontWeight.w600,
            ),
            bodyText2: const TextStyle(
              fontSize: 15.5,
              height: 1.02,
              fontWeight: FontWeight.w500,
            ),
            button: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              wordSpacing: 1,
            ),

          );

  final myTheme = ThemeData.from(
    colorScheme: ColorScheme.light(
      primary: ColorPalette.purple,
    ),
    textTheme: myTextTheme,
  ).copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: const Size(200, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      primary: Colors.black,
      minimumSize: const Size(200, 52),
      side: const BorderSide(width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    )),

  );
}
