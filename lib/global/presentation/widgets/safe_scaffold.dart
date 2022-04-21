import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  const SafeScaffold({
    Key? key,
    this.appBar,
    this.backgroundColor,
    required this.child,
    this.bottom,
  }) : super(key: key);

  final Widget child;
  final Widget? bottom;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        body: SafeArea(child: child),
      bottomNavigationBar: bottom
      );
}
