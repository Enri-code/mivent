import 'package:flutter/material.dart';

class NavAppBar extends AppBar {
  static const backIcon = Icons.arrow_back_ios_new_rounded;
  NavAppBar({
    Key? key,
    Widget? title,
    Color? foregroundColor,
    Color? backgroundColor,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          titleTextStyle: TextStyle(color: foregroundColor, fontSize: 18),
          leading: onPressed != null
              ? Hero(
                  tag: 'back_button',
                  transitionOnUserGestures: true,
                  child: _BackButton(
                      onPressed: onPressed, foregroundColor: foregroundColor),
                )
              : null,
          elevation: 0,
          title: title,
          backgroundColor: backgroundColor,
        );
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key, required this.onPressed, this.foregroundColor})
      : super(key: key);

  final Color? foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: IconButton(
        splashRadius: 18,
        color: foregroundColor,
        padding: EdgeInsets.zero,
        icon: const Icon(NavAppBar.backIcon),
        onPressed: onPressed,
      ),
    );
  }
}
