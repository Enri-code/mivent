import 'package:flutter/material.dart';
import 'package:mivent/features/events/presentation/screens/event_details.dart';
import 'package:mivent/features/events/presentation/widgets/card.dart';
import 'package:mivent/features/events/presentation/widgets/tile.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/events/domain/entities/event.dart';

enum EventSectionType { card, tile }

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
  final VoidCallback? moreOnPressed;
  final double? mainAxisSize;
  final List<Event>? events;
  final EventSectionType type;
  final Function(int)? onEventPressed;

  static final _default = Event(
    id: null,
    name: 'Finding...',
    location: '',
    dates: null,
    image: null,
    liked: false,
    hasTicket: false,
    prices: null,
  );

  @override
  State<EventSection> createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {
  _detailsPageBuilder(int i) {
    if (widget.onEventPressed != null) {
      widget.onEventPressed!(i);
    } else {
      /* Navigator.of(context).pushNamed(
      EventDetailsScreen.routeName,
      arguments: [widget.events![i], key],
    ); */
      Navigator.of(context).push(
        PageRouteBuilder(
          settings: RouteSettings(arguments: widget.events![i]),
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => const EventDetailsScreen(),
          transitionsBuilder: (_, animation1, __, child) =>
              FadeTransition(opacity: animation1, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      return Column(
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title!, style: TextStyles.subHeader1),
                  Visibility(
                    visible: widget.moreOnPressed != null,
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true,
                    child: TextButton(
                      child: const Text('See more'),
                      onPressed: widget.moreOnPressed,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          () {
            if (widget.type == EventSectionType.tile) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    widget.events?.length ?? 3,
                    (i) => Column(
                      children: [
                        SizedBox(
                          height: ((widget.mainAxisSize ?? 100) + 15)
                              .clamp(110, 150),
                          child: EventListTile(
                            widget.events?[i] ?? EventSection._default,
                            onPressed: widget.events != null
                                ? () => _detailsPageBuilder(i)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                physics: widget.events == null
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                itemCount: widget.events?.length ?? 2,
                itemBuilder: (_, i) {
                  return SizedBox(
                    width: widget.mainAxisSize ?? cons.biggest.height * 0.75,
                    child: EventCard(
                      widget.events?[i] ?? EventSection._default,
                      onPressed: widget.events != null
                          ? () => _detailsPageBuilder(i)
                          : null,
                    ),
                  );
                },
              ),
            );
          }(),
        ],
      );
    });
  }
}
