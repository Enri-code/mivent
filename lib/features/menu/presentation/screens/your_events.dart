import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';
import 'package:mivent/features/events/presentation/widgets/tile.dart';
import 'package:mivent/features/store/presentation/bloc/events_store.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/samples/data.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class YourEventsPage extends StatefulWidget {
  const YourEventsPage({Key? key}) : super(key: key);

  @override
  State<YourEventsPage> createState() => _YourEventsPageState();
}

class _YourEventsPageState extends State<YourEventsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeScaffold(
        appBar: AppBar(
          elevation: 8,
          toolbarHeight: 61,
          shadowColor: Colors.black26,
          flexibleSpace: const TabBar(
            indicatorWeight: 3,
            labelStyle: TextStyles.subHeader1,
            labelColor: Color(0xFF582F7E),
            indicatorColor: ColorPalette.primary,
            padding: EdgeInsets.fromLTRB(24, 8, 24, 2),
            unselectedLabelColor: Color(0xFFB298CA),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: '  Attending  '),
              Tab(text: '  Saved  '),
            ],
          ),
        ),
        // ignore: prefer_const_constructors
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const _AttendingEvents(),
            // ignore: prefer_const_constructors
            _SavedEvents(),
          ],
        ),
      ),
    );
  }
}

class _SavedEvents extends StatefulWidget {
  const _SavedEvents({Key? key}) : super(key: key);

  @override
  State<_SavedEvents> createState() => _SavedEventsState();
}

class _SavedEventsState extends State<_SavedEvents> {
  var _key = GlobalKey<AnimatedListState>();
  @override
  void didUpdateWidget(covariant _SavedEvents oldWidget) {
    _key = GlobalKey<AnimatedListState>();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var items = context.watch<EventStore>().state.store.items;

    ///TODO: Retrieve event image and other data that wasn't saved offline
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AnimatedOpacity(
          duration: kThemeAnimationDuration,
          opacity: (items as List).isEmpty ? 1 : 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("There are no saved events!", style: TextStyles.header4),
              SizedBox(height: 32),
              FractionallySizedBox(
                widthFactor: 0.2,
                child: FittedBox(
                  child:
                      Icon(MiventIcons.favourite_outlined, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        AnimatedList(
          key: _key,
          initialItemCount: (items as List).length,
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          itemBuilder: (_, i, anim) {
            var event = (items as List)[i] as Event;
            return _Tile(
              event: event,
              onSaveStateChanged: () => _key.currentState!.removeItem(
                i,
                (_, anim) => SizeTransition(
                  sizeFactor: anim,
                  axisAlignment: 1,
                  child: FadeTransition(
                    opacity: anim,
                    child: _Tile(event: event),
                  ),
                ),
                duration: kThemeAnimationDuration,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    Key? key,
    required this.event,
    this.onSaveStateChanged,
  }) : super(key: key);

  final Event event;
  final Function()? onSaveStateChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        height: 115,
        child: EventListTile(
          event,
          onSaveStateChanged: (val) => onSaveStateChanged?.call(),
        ),
      ),
    );
  }
}

class _AttendingEvents extends StatefulWidget {
  const _AttendingEvents({
    Key? key,
  }) : super(key: key);

  @override
  State<_AttendingEvents> createState() => _AttendingEventsState();
}

class _AttendingEventsState extends State<_AttendingEvents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: EventSection(
        events: SampleData.eventsPreview,
        type: EventSectionType.tile,
      ),
    );
  }
}
