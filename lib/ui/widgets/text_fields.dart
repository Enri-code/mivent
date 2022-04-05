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
  final VoidCallback? onChanged;

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
      suffixIcon: IconButton(
        icon: Icon(hideText ? Icons.visibility : Icons.visibility_off),
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
    this.hideText = false,
    this.suffixIcon,
  }) : super(key: key);

  final String label;
  final bool hideText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String)? validator;
  final VoidCallback? onChanged;

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
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        ),
        toolbarOptions: const ToolbarOptions(selectAll: true, paste: true),
        onChanged: onChanged != null ? (_) => onChanged!() : null,
        validator: (val) => validator?.call(val ?? ''),
      ),
    );
  }
}
