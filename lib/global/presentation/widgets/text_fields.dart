import 'package:flutter/material.dart';

class PasswordFormWidget extends StatefulWidget {
  const PasswordFormWidget({
    Key? key,
    this.label = 'Password',
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final String? Function(String)? validator;
  final Function(String)? onChanged;

  @override
  State<PasswordFormWidget> createState() => _PasswordFormWidgetState();
}

class _PasswordFormWidgetState extends State<PasswordFormWidget> {
  var hideText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormWidget(
      label: widget.label,
      hideText: hideText,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(hideText ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => hideText = !hideText),
      ),
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    Key? key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.backgroundColor,
    this.hideText = false,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  final String label;
  final bool hideText;
  final Color? backgroundColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: hideText,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: backgroundColor != null,
          fillColor: backgroundColor,
        ),
        toolbarOptions: const ToolbarOptions(selectAll: true, paste: true),
        validator: (val) => validator?.call(val ?? ''),
        onChanged: onChanged,
      ),
    );
  }
}
