import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mivent/core/services/media.dart';
import 'package:mivent/features/events/presentation/screens/event_tickets.dart';
import 'package:mivent/features/events/presentation/widgets/saved_button.dart';
import 'package:mivent/features/events/presentation/widgets/map_frame.dart';
import 'package:mivent/features/share/data/models/event.dart';
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
  static const routeName = '/event_details';
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  Animation<double>? pageAnim;
  EventDetail? _detail;

  var transitionDone = false;

  @override
  void didChangeDependencies() {
    pageAnim = ModalRoute.of(context)!.animation
      ?..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) setState(() => transitionDone = true);
        }
      });
    _detail = EventDetail(
      ModalRoute.of(context)!.settings.arguments as Event,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var detail = _detail!;
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
                    onTap: detail.image != null
                        ? () {
                            Navigator.of(context).pushNamed(
                              ImageFullView.routeName,
                              arguments: ImageFullViewData(
                                heroTag: 'image_${detail.id}',
                                image: detail.image,
                              ),
                            );
                          }
                        : null,
                    child: Hero(
                      tag: 'image_${detail.id}',
                      child: ImageFrame(image: detail.image),
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
                parent: pageAnim!,
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
                        child: Text(detail.name, style: TextStyles.header4),
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
                              title: detail.dates!.range,
                              icon: Icons.calendar_month,
                            ),
                            _SubInfo(
                              title: detail.location,
                              icon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      ),
                      _Details(detail: detail, transitionDone: transitionDone),
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
                            MediaService.shareText(ShareableEvent(detail)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: detail.hasTicket
                        ? Hero(
                            tag: 'checkout_button',
                            transitionOnUserGestures: true,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: ColorPalette.secondaryColor),
                              child: const Text('Get tickets'),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  EventTicketsScreen.routeName,
                                  arguments: detail,
                                );
                              },
                            ),
                          )
                        : ElevatedButton(
                            //TODO add cancel attendance button
                            child: const Text('Attend'),
                            onPressed: () {
                              //TODO add Attend logic
                            },
                          ),
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
                      event: detail,
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

class _Details extends StatefulWidget {
  const _Details({
    Key? key,
    required this.detail,
    required this.transitionDone,
  }) : super(key: key);

  final EventDetail detail;
  final bool transitionDone;

  @override
  State<_Details> createState() => _DetailsState();
}

class _DetailsState extends State<_Details> {
  var dataLoaded = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000)).then((_) {
      if (mounted)
        setState(() {
          dataLoaded = true;
          widget.detail
            ..mapPosition = const LatLng(6.864476, 7.408224)
            ..description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem cum tristique eros, porttitor.'
                ' Mauris, sed malesuada nunc montes, non vitae cras enim quam. Convallis egestas sed in sagittis at.'
                ' Dui, lacus eget urna pellentesque viverra at nullam libero nulla.'
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ' Lorem cum tristique eros, porttitor. Mauris, sed malesuada nunc montes,'
                ' non vitae cras enim quam. Convallis egestas sed in sagittis at.'
                ' Dui, lacus eget urna pellentesque viverra at nullam libero nulla.';
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///Check if event was not found, and tell user
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!dataLoaded)
          const Padding(
            padding: EdgeInsets.only(top: 120),
            child: Center(child: CircularProgressIndicator()),
          ),
        const SizedBox(height: 32),
        if (widget.detail.mapPosition != null)
          const Text('Location', style: TextStyles.subHeader1),
        const SizedBox(height: 16),
        if (widget.detail.mapPosition != null)
          AspectRatio(
            aspectRatio: 1.7,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: widget.transitionDone
                  ? MapWidget(widget.detail.mapPosition!)
                  : null,
            ),
          ),
        const SizedBox(height: 32),
        if (widget.detail.description.isNotEmpty)
          const Text('About', style: TextStyles.subHeader1),
        const SizedBox(height: 10),
        Text(
          widget.detail.description,
          style: TextStyle(height: 1.6, color: Colors.grey[700]!),
        ),
      ],
    );
  }
}
