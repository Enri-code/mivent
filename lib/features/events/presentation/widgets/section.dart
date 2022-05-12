import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mivent/features/events/presentation/screens/event_details.dart';
import 'package:mivent/features/events/presentation/widgets/card.dart';
import 'package:mivent/features/events/presentation/widgets/tile.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/events/domain/entities/event.dart';

abstract class EventSectionType {
  static final List _types = [CardSectionType(), TileSectionType()];
  static EventSectionType get random => _types[Random().nextInt(_types.length)];
}

class CardSectionType extends EventSectionType {}

class TileSectionType extends EventSectionType {}

class EventSection extends StatefulWidget {
  const EventSection({
    Key? key,
    required this.events,
    required this.type,
    this.title,
    this.moreOnPressed,
    this.mainAxisSize,
    this.onEventPressed,
  }) : super(key: key);

  final String? title;
  final double? mainAxisSize;
  final List<Event>? events;
  final EventSectionType type;
  final VoidCallback? moreOnPressed;
  final Function(int)? onEventPressed;

  @override
  State<EventSection> createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {
  static final _placeHolder = Event(
      id: '',
      name: 'Finding...',
      location: '',
      dates: null,
      imageGetter: null,
      liked: false,
      prices: null,
      hasTicket: false,
      attendersCount: 0);

  _detailsPageBuilder(int i) {
    if (widget.onEventPressed != null) {
      widget.onEventPressed!(i);
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
            settings: RouteSettings(arguments: widget.events![i]),
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => const EventDetailsScreen(),
            transitionsBuilder: (_, animation1, __, child) => child
            //FadeTransition(opacity: animation1, child: child),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          _Title(title: widget.title!, moreOnPressed: widget.moreOnPressed),
        if (widget.type is CardSectionType)
          SizedBox(
            height: widget.mainAxisSize ?? 300,
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              physics: widget.events == null
                  ? const NeverScrollableScrollPhysics()
                  : null,
              itemCount: widget.events?.length,
              itemBuilder: (_, i) => AspectRatio(
                aspectRatio: 4 / 5,
                child: EventCard(
                  widget.events?[i] ?? _placeHolder,
                  onPressed: widget.events != null
                      ? () => _detailsPageBuilder(i)
                      : null,
                ),
              ),
            ),
          )
        else
          ...List.generate(
            widget.events?.length ?? 3,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SizedBox(
                height: ((widget.mainAxisSize ?? 100) + 15).clamp(110, 150),
                child: EventListTile(
                  widget.events?[i] ?? _placeHolder,
                  onPressed: widget.events != null
                      ? () => _detailsPageBuilder(i)
                      : null,
                ),
              ),
            ),
          ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
    required this.title,
    required this.moreOnPressed,
  }) : super(key: key);

  final String title;
  final Function()? moreOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.subHeader1),
          Visibility(
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            visible: moreOnPressed != null,
            child: TextButton(
              onPressed: moreOnPressed,
              child: const Text('See more'),
            ),
          ),
        ],
      ),
    );
  }
}
