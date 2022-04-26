import 'package:flutter/material.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

class NavAppBar extends AppBar {
  static const backIcon = Icons.arrow_back_ios_new_rounded;
  NavAppBar({
    Key? key,
    Widget? title,
    double elevation = 0,
    Color? backgroundColor,
    Color foregroundColor = Colors.black,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          toolbarHeight: 65,
          shadowColor: Colors.black26,
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyles.header4.copyWith(color: foregroundColor),
          leading: onPressed != null
              ? Hero(
                  tag: 'back_button',
                  transitionOnUserGestures: true,
                  child: _BackButton(
                      onPressed: onPressed, foregroundColor: foregroundColor),
                )
              : null,
          elevation: elevation,
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
