import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/presentation/widgets/saved_button.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/image_frame.dart';
import 'package:mivent/global/presentation/widgets/ink_material.dart';

import '../bloc/event/event_bloc.dart';

class EventListTile extends StatelessWidget {
  const EventListTile(
    this.event, {
    Key? key,
    this.onPressed,
    this.onSaveStateChanged,
  }) : super(key: key);

  final Event event;
  final VoidCallback? onPressed;
  final Function(bool)? onSaveStateChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 4, color: Colors.white),
        boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26)],
      ),
      child: Stack(
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(12),
            child: InkMaterial(
              child: InkResponse(
                onTap: onPressed,
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                child: Row(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(4)),
                      child: AspectRatio(
                        aspectRatio: 1.2,
                        child: ImageFutureFrame(event.imageGetter),
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
                                  child: EventSavedButtonWidget(
                                    event: event,
                                    onSaveStateChanged: (val) =>
                                        onSaveStateChanged?.call(val),
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
          if (context.watch<EventsBloc>().isUserAttending(event))
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
