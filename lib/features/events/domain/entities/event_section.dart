import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';

class EventSectionData {
  EventSectionData({
    required this.provider,
    this.id,
    this.status = OperationStatus.initial,
  }) {
    result = provider.getEvents();
  }

  final int? id;
  final IEventSectionRepo provider;
  late final Future<List<Event>> result;
  OperationStatus status;

  @override
  operator ==(dynamic other) =>
      other is EventSectionData && other.id == id && other.provider == provider;

  @override
  int get hashCode => id.hashCode + provider.hashCode;
}
