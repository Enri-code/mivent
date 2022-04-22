import 'package:flutter/material.dart';
import 'package:mivent/features/menu/presentation/widgets/bubbles.dart';
import 'package:mivent/features/menu/presentation/widgets/event_widgets.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/samples/data.dart';
import 'package:mivent/global/presentation/widgets/text_fields.dart';

class DicoverPage extends StatelessWidget {
  const DicoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const BubblesWidget(),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Events',
                            style: TextStyles.header1.copyWith(
                              fontSize: 32,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'waiting for you',
                            style: TextStyles.header1.copyWith(
                              height: 1.2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 64,
                  child: TextFormWidget(
                    label: 'Find events',
                    backgroundColor: Colors.white70,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: EventSection(
                    title: 'Popular',
                    type: EventSectionType.card,
                    events: SampleData.eventsPreview,
                  ),
                ),
                const SizedBox(height: 26),
                EventSection(
                  title: 'This month',
                  type: EventSectionType.tile,
                  events: SampleData.eventsPreview,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
