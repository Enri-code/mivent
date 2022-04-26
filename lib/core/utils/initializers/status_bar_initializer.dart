import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:mivent/global/presentation/theme/colors.dart';

class StatusBarInitializer {
  StatusBarInitializer._();

  bool? _useWhiteStatusBarForeground;
  static StatusBarInitializer? _instance;
  factory StatusBarInitializer.instance() =>
      _instance ??= _instance = StatusBarInitializer._();

  mainInit() {
    FlutterStatusbarcolor.setStatusBarColor(ColorPalette.appBarColor).then((_) {
      if (useWhiteForeground(ColorPalette.appBarColor)) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        _useWhiteStatusBarForeground = true;
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        _useWhiteStatusBarForeground = false;
      }
    });
  }

  update(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _useWhiteStatusBarForeground != null) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(
          _useWhiteStatusBarForeground!);
    }
  }
}
