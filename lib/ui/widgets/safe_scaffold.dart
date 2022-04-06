import 'package:flutter/material.dart';

class SafeScaffold extends StatelessWidget {
  const SafeScaffold({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.appBar,
  }) : super(key: key);

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor,
        body: SafeArea(child: child),
      );
}
