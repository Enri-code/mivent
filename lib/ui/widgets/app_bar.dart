import 'package:flutter/material.dart';

class NavAppBar extends AppBar {
  NavAppBar({
    Key? key,
    this.title,
    this.hasBackButton = true,
    required this.onPressed,
  }) : super(
          key: key,
          centerTitle: true,
          leading: hasBackButton
              ? IconButton(
                iconSize: 32,
                splashRadius: 18,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.comfortable,
                icon: const Icon(
                  Icons.arrow_circle_left_outlined,
                  color: Colors.black,
                ),
                onPressed: onPressed,
              )
              : null,
          elevation: 0,
          title: title,
          backgroundColor: Colors.white,
        );

  final Widget? title;
  final bool hasBackButton;
  final Function() onPressed;
}
