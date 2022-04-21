import 'package:flutter/material.dart';
import 'package:mivent/features/menu/presentation/widgets/event_widgets.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/samples/data.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class YourEventsPage extends StatefulWidget {
  const YourEventsPage({Key? key}) : super(key: key);

  @override
  State<YourEventsPage> createState() => _YourEventsPageState();
}

class _YourEventsPageState extends State<YourEventsPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorWeight: 3,
              labelStyle: TextStyles.subHeader1,
              labelColor: Color(0xFF582F7E),
              indicatorColor: ColorPalette.primary,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              unselectedLabelColor: Color(0xFFB298CA),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'Attending'),
                Tab(text: 'Saved'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: EventSection(
                      events: SampleData.eventsPreview,
                      type: EventSectionType.tile,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: EventSection(
                      events: SampleData.eventsPreview,
                      type: EventSectionType.tile,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
