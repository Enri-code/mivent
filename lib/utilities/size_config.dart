/// Library to handle responsive layout.
library responsive_layout;

import 'package:flutter/material.dart';

extension ResponsiveNum on num {
  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth, _screenHeight, _widthInPx, _heightInPx;

  static init(BuildContext context,
      {required double refWidth, required double refHeight}) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _heightInPx = refHeight;
    _widthInPx = refWidth;
  }

  double h() => (this / _heightInPx) * _screenHeight;
  double w() => (this / _widthInPx) * _screenWidth;
  double ofHeight() => _screenHeight * this;
  double ofWidth() => _screenWidth * this;
}

extension ResponsiveSize on Size {
  s() => Size(width.w(), height.h());
}

/// Wraper that handles responsive layout.
///
/// wrap root widget below [MaterialApp] with [Responsive] widget.
/// [screenHeight] and [screenWidth] refers to the height and width of the figma design.
/// A default value of 1920 and 1080 was set.
///
/// Api usage
///
/// ```dart
/// Container(
///  height: 30.h(),
///  width: 30.w())
///```
///to get a percentage of the default screen height
///```dart
///height: 1.defaultHeight(),
///```
///where the height return is the default height divided by [this]
class Responsive extends StatefulWidget {
  final Widget child;
  final double screenWidth, screenHeight;
  const Responsive({
    Key? key,
    required this.child,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  void didChangeDependencies() {
    ResponsiveNum.init(context,
        refWidth: widget.screenWidth, refHeight: widget.screenHeight);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
