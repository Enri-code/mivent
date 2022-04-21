import 'package:flutter/material.dart';
import 'package:mivent/features/events/presentation/screens/event_details.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/events/domain/models/event.dart';
import 'package:mivent/global/presentation/widgets/image_frame.dart';
import 'package:mivent/global/presentation/widgets/ink_material.dart';
import 'package:mivent/global/presentation/widgets/switch_button.dart';

enum EventSectionType { card, tile }

class EventCard extends StatelessWidget {
  const EventCard(
    this.event, {
    Key? key,
    this.onPressed,
    this.tagId = '',
  }) : super(key: key);

  final String tagId;
  final Event event;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(width: 5, color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
      ),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(12),
        child: InkMaterial(
          child: InkResponse(
            onTap: onPressed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(6),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'image_${tagId}_${event.id}',
                          transitionOnUserGestures: true,
                          child: ImageFrame(image: event.image),
                        ),
                        //TODO: add users going images urls
                        /*
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-0.2, 0.2),
                              end: Alignment(-0.5, 1),
                              colors: [Colors.transparent, Colors.black38],
                            ),
                          ),
                        ),
                          Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Stack(
                              children: List.generate(
                                4,
                                (i) => Container(
                                  width: 24,
                                  height: 24,
                                  margin: EdgeInsets.only(left: i * 16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(''),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ), */
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.black,
                          height: 1,
                          fontWeight: FontWeight.w500,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(event.name,
                                      style: TextStyles.subHeader2),
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(event.location),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.dates?.fromDateShort ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    event.prices?.range ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SwitchWidget(
                                  onWidget: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      MiventIcons.favourite,
                                      color: ColorPalette.favouriteColor,
                                      size: 18,
                                    ),
                                  ),
                                  offWidget: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      MiventIcons.favourite_outlined,
                                      size: 18,
                                    ),
                                  ),
                                  initialState: event.liked,
                                  onSwitched: (val) {
                                    //TODO: set saved state and store it in database
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (false) //TODO: Check if user is already going to event
                      const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.check_circle_outline,
                          color: ColorPalette.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventListTile extends StatelessWidget {
  const EventListTile(
    this.event, {
    Key? key,
    this.onPressed,
    this.tagId = '',
  }) : super(key: key);

  final Event event;
  final String tagId;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 5, color: Colors.white),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: Stack(
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(12),
            child: InkMaterial(
              child: InkResponse(
                onTap: onPressed,
                child: Row(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(4)),
                      child: AspectRatio(
                        aspectRatio: 1.2,
                        child: Hero(
                          tag: 'image_${tagId}_${event.id}',
                          transitionOnUserGestures: true,
                          child: ImageFrame(image: event.image),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            height: 0.92,
                            fontSize: 13.5,
                            color: Colors.black,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 24),
                                        child: Text(
                                          event.name,
                                          style: TextStyles.subHeader2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Expanded(child: Text(event.location)),
                                  const SizedBox(height: 3),
                                  Expanded(
                                    child: Text(
                                      event.dates?.fromDateShort ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Expanded(
                                    child: Text(
                                      event.prices?.range ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: SwitchWidget(
                                    onWidget: const Icon(
                                      MiventIcons.favourite,
                                      size: 18,
                                      color: ColorPalette.favouriteColor,
                                    ),
                                    offWidget: const Icon(
                                      MiventIcons.favourite_outlined,
                                      size: 18,
                                    ),
                                    initialState: event.liked,
                                    onSwitched: (val) {
                                      //TODO: set saved state and store it in database
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (false) //TODO: Check if user is already going to event
            const Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.check_circle_outline,
                color: ColorPalette.primary,
              ),
            ),
        ],
      ),
    );
  }
}

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
  final key = UniqueKey().hashCode.toString();

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
          settings: RouteSettings(arguments: [widget.events![i], key]),
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
                            tagId: key,
                            onPressed: widget.events != null
                                ? () => _detailsPageBuilder(i)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                      tagId: key,
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
