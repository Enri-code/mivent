import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/events/domain/entities/details.dart';
import 'package:mivent/features/events/domain/repos/get_details.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';
import 'package:mivent/features/events/presentation/screens/event_tickets.dart';
import 'package:mivent/features/events/presentation/widgets/saved_button.dart';
import 'package:mivent/features/events/presentation/widgets/map_frame.dart';
import 'package:mivent/global/data/toast.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/global/presentation/widgets/app_bar.dart';
import 'package:mivent/global/presentation/widgets/custom_scroll_view.dart';
import 'package:mivent/global/presentation/screens/image_full_view.dart';
import 'package:mivent/global/presentation/widgets/image_frame.dart';

class _SubInfo extends StatelessWidget {
  const _SubInfo({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Icon(icon, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

class EventDetailsScreen extends StatefulWidget {
  static const route = '/event_details';
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event event;
  late Animation<double> pageAnim;
  ImageProvider<Object>? image;
  EventDetail? details;

  ///TODO: better ui designs
  bool hasError = false, isEmpty = false, transitionDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _doneAnimating(AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => transitionDone = true);
        if (mounted) pageAnim.removeStatusListener(_doneAnimating);
      }
    }

    pageAnim = ModalRoute.of(context)!.animation!
      ..addStatusListener(_doneAnimating);

    if (details == null && !isEmpty && !hasError) {
      event = ModalRoute.of(context)!.settings.arguments as Event;
      Future.value(event.imageGetter).then((value) {
        if (mounted && value != null) {
          setState(() => image = MemoryImage(value));
        }
      });
      context.read<IEventDetails>().getDetails(event.id).then((value) {
        if (mounted) {
          value.fold(
            (l) => setState(() => hasError = true),
            (r) => setState(() {
              details = r;
              isEmpty = r == null;
            }),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var attending = context.watch<EventsBloc>().isUserAttending(event);
    return Material(
      type: transitionDone ? MaterialType.canvas : MaterialType.transparency,
      child: Stack(
        children: [
          OverlappedHeaderScrollView(
            clipBehaviour: Clip.none,
            headerMinHeight: 86 + MediaQuery.of(context).viewPadding.top,
            header: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: image != null
                        ? () {
                            Navigator.of(context).pushNamed(
                              ImageFullView.route,
                              arguments: ImageFullViewData(
                                  heroTag: 'image_${event.id}', image: image),
                            );
                          }
                        : null,
                    child: Hero(
                      tag: 'image_${event.id}',
                      child: FadeTransition(
                        opacity: pageAnim,
                        child: ImageFrame(image: image),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(NavAppBar.backIcon, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SlideTransition(
              position: CurvedAnimation(
                parent: pageAnim,
                curve: Curves.easeOut,
              ).drive(Tween(begin: const Offset(0, 1), end: Offset.zero)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.width +
                      25,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(blurRadius: 12, color: Colors.black38)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Center(
                        child: Text(event.name, style: TextStyles.header4),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            _SubInfo(
                              title: event.dates!.range,
                              icon: Icons.calendar_month,
                            ),
                            _SubInfo(
                              title: event.location,
                              icon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      ),
                      if (isEmpty)
                        const Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              'This event is currently unavailable or has expired',
                            ))
                      else if (hasError)
                        const Padding(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              "There was an error loading this event's details",
                            ))
                      else
                        _Details(
                          event: event,
                          details: details,
                          transitionDone: transitionDone,
                        ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          offset: Offset(0, 2),
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      shape: const CircleBorder(),
                      child: IconButton(
                        padding: const EdgeInsets.all(9),
                        iconSize: 26,
                        icon: const Icon(Icons.share),
                        onPressed: () =>
                            throw UnimplementedError(), //TODO: share button
                      ),
                    ),
                  ),
                  BlocListener<EventsBloc, EventsState>(
                    listener: (context, state) {
                      if (state.status == OperationStatus.minorFail) {
                        if (!attending) {
                          ToastManager.error(
                            title: "Couldn't attend event",
                            body: state.failure!.message ??
                                'There was a problem registering you to the event. Please try again later',
                          );
                        } else if (attending) {
                          ToastManager.error(
                            title: "Couldn't remove your attendance",
                            body: state.failure!.message ??
                                'There was a problem unattending this event. Please try again later',
                          );
                        }
                      } else if (state.status == OperationStatus.success) {
                        setState(() => event = state.updatedEvent ?? event);
                      }
                    },
                    child: const SizedBox(width: 16),
                  ),
                  Expanded(
                    child: () {
                      if (event.hasTicket) {
                        return Hero(
                          tag: 'checkout_button',
                          transitionOnUserGestures: true,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: ColorPalette.secondaryColor),
                            child: const Text('Get tickets'),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                EventTicketsScreen.route,
                                arguments: event,
                              );
                            },
                          ),
                        );
                      }
                      if (details == null) return const SizedBox();
                      if (attending) {
                        return ElevatedButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            context
                                .read<EventsBloc>()
                                .add(CancelAttendanceEvent(event));
                          },
                        );
                      }
                      return ElevatedButton(
                        child: const Text('Attend'),
                        onPressed: () {
                          context.read<EventsBloc>().add(AttendEvent(event));
                        },
                      );
                    }(),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          offset: Offset(0, 2),
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: EventSavedButtonWidget(
                      event: event,
                      iconSize: 22,
                      padding: const EdgeInsets.all(11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    Key? key,
    required this.event,
    required this.details,
    required this.transitionDone,
  }) : super(key: key);

  final Event event;
  final bool transitionDone;
  final EventDetail? details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        if (details == null)
          const Padding(
            padding: EdgeInsets.only(top: 90),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (details!.mapPoint != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Location', style: TextStyles.subHeader1),
                    const SizedBox(height: 24),
                    AspectRatio(
                      aspectRatio: 1.6,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: transitionDone
                            ? MapWidget(details!.mapPoint!,
                                name: event.location)
                            : null,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              if (details!.description.isNotEmpty)
                const Text('About', style: TextStyles.subHeader1),
              const SizedBox(height: 20),
              Text(
                details!.description,
                style: TextStyle(height: 1.7, color: Colors.grey[600]!),
              ),
            ],
          ),
      ],
    );
  }
}
