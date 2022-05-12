import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mivent/global/presentation/widgets/toast_widgets.dart';

class ToastManager {
  static final _fToast = FToast();
  static init(BuildContext context) {
    _fToast.init(context);
  }

  static customToast(Widget widget,
      {Duration duration = const Duration(milliseconds: 3000),
      bool urgent = false}) {
    if (urgent) {
      _fToast
        ..removeCustomToast()
        ..removeQueuedCustomToasts();
    }
    _fToast.showToast(
      child: widget,
      positionedToastBuilder: (_, child) =>
          Positioned(top: 0, left: 0, right: 0, child: child),
      gravity: ToastGravity.TOP,
      toastDuration: duration,
      fadeDuration: 300,
    );
  }

  static success({String title = 'Success', String? body, Function()? onTap}) {
    customToast(ToastWidget(
      title: title,
      body: body,
      color: Colors.green,
      icon: Icons.check_circle_outline_outlined,
      onTap: onTap,
    ));
  }

  static info({String title = 'Info', String? body, Function()? onTap}) =>
      customToast(ToastWidget(title: title, body: body, onTap: onTap));

  static error({String title = 'Error', String? body, Function()? onTap}) {
    _fToast.removeCustomToast();
    customToast(ToastWidget(
      title: title,
      body: body,
      color: Colors.red,
      icon: Icons.error_outline,
      onTap: onTap,
    ));
  }

  static remove() => _fToast.removeCustomToast();
}
