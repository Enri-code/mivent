part of 'remote_events_bloc.dart';

abstract class RemoteEventsEvent extends Equatable {
  const RemoteEventsEvent();
  @override
  List<Object> get props => [];
}

class AddSectionEvent extends RemoteEventsEvent {
  const AddSectionEvent(this.data);
  final EventSectionData data;
  @override
  List<Object> get props => [data];
}

class SectionErrorEvent extends RemoteEventsEvent {
  const SectionErrorEvent(this.data);
  final EventSectionData data;
  @override
  List<Object> get props => [data];
}

class SectionSuccessEvent extends RemoteEventsEvent {
  const SectionSuccessEvent(this.data);
  final EventSectionData data;
  @override
  List<Object> get props => [data];
}
