import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/sections.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';

abstract class IEventSectionRepo {
  IRemoteEventsProvider get repo;

  bool get showMore;
  String? get title;
  Object? get lastEventRef;
  EventSectionType? get type;

  Future<List<Event>> getEvents([int limit = 5]);

  @override
  operator ==(dynamic other) =>
      other is IEventSectionRepo &&
      other.type.runtimeType == type.runtimeType &&
      other.title == title;

  @override
  int get hashCode => title.hashCode;
}
