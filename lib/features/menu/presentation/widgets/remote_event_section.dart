import 'package:flutter/material.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/entities/event_section.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';

///TODO: change logic and UI
class RemoteEventSection extends StatefulWidget {
  const RemoteEventSection(this.data, {Key? key, this.onStatusChanged})
      : super(key: key);
  final EventSectionData data;
  final Function(OperationStatus, EventSectionData)? onStatusChanged;

  @override
  State<RemoteEventSection> createState() => _RemoteEventSectionState();
}

class _RemoteEventSectionState extends State<RemoteEventSection> {
  late final EventSectionType type;

  @override
  void initState() {
    type = widget.data.provider.type ?? EventSectionType.random;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.data.result,
      builder: (_, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            widget.onStatusChanged?.call(OperationStatus.success, widget.data);
            return EventSection(
              type: type,
              events: snapshot.data,
              title: widget.data.provider.title,

              ///TODO: show more button
              moreOnPressed: widget.data.provider.showMore ? () {} : null,
            );
          } else {
            return const Center(
                child: Text("We couldn't find any events to display here"));
          }
        }
        String? title;
        if (snapshot.hasError) {
          print(snapshot.error);
          print(widget.data.provider.runtimeType);
          widget.onStatusChanged?.call(OperationStatus.minorFail, widget.data);
          title = 'An error occured';
        } else if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          title = widget.data.provider.title;
        } else {
          title = 'No events here';
        }
        return EventSection(events: null, type: type, title: title);
      },
    );
  }
}
