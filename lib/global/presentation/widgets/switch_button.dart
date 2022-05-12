import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mivent/global/presentation/widgets/ink_material.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({
    Key? key,
    required this.offWidget,
    required this.onWidget,
    required this.onSwitched,
    this.state = false,
  }) : super(key: key);

  final bool state;
  final Widget offWidget, onWidget;
  final FutureOr Function(bool)? onSwitched;

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool state;

  @override
  Widget build(BuildContext context) {
    state = widget.state;
    return InkMaterial(
      child: InkResponse(
        onTap: widget.onSwitched != null
            ? () async {
                setState(() => state = !state);
                try {
                  await widget.onSwitched!(state);
                } catch (e) {
                  setState(() => state = !state);
                }
              }
            : null,
        child: AnimatedCrossFade(
          crossFadeState:
              state ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          firstChild: widget.offWidget,
          secondChild: widget.onWidget,
        ),
      ),
    );
  }
}
