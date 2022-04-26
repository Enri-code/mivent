import 'package:flutter/material.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/presentation/widgets/saved_button.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/image_frame.dart';
import 'package:mivent/global/presentation/widgets/ink_material.dart';

class EventCard extends StatelessWidget {
  const EventCard(
    this.event, {
    Key? key,
    this.onPressed,
  }) : super(key: key);

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
        boxShadow: const [BoxShadow(blurRadius: 16, color: Colors.black12)],
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
                        ImageFrame(image: event.image),
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
                        ),
                        */
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
                                EventSavedButtonWidget(event: event),
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
