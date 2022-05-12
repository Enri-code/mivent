import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/store/data/stores/mixins.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';
import 'package:mivent/global/presentation/widgets/switch_button.dart';

class EventSavedButtonWidget extends StatelessWidget {
  const EventSavedButtonWidget({
    Key? key,
    required this.event,
    this.padding = const EdgeInsets.all(4),
    this.iconSize = 20,
    this.onSaveStateChanged,
  }) : super(key: key);

  final EdgeInsets padding;
  final double iconSize;
  final Event event;
  final Function(bool)? onSaveStateChanged;

  @override
  Widget build(BuildContext context) {
    var store = context.watch<SavedEventsStore>();
    return SwitchWidget(
      onWidget: Padding(
        padding: padding,
        child: Icon(MiventIcons.favourite,
            size: iconSize, color: ColorPalette.favouriteColor),
      ),
      offWidget: Padding(
        padding: padding,
        child: Icon(MiventIcons.favourite_outlined, size: iconSize),
      ),
      state: store.contains(event),
      onSwitched: event.id.isNotEmpty
          ? (val) {
              if (val) {
                store.put(event);
              } else {
                store.remove(event);
              }
              onSaveStateChanged?.call(val);
            }
          : null,
    );
  }
}
