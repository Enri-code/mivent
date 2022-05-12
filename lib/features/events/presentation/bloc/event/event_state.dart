part of 'event_bloc.dart';

class EventsState extends Equatable {
  const EventsState({
    this.status = OperationStatus.initial,
    this.failure,
    this.updatedEvent,
  });

  final Failure? failure;
  final Event? updatedEvent;
  final OperationStatus status;

  EventsState copyWith(
          {OperationStatus? status, Failure? failure, Event? updatedEvent}) =>
      EventsState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        updatedEvent: updatedEvent ?? this.updatedEvent,
      );

  @override
  List<Object?> get props => [status, updatedEvent, failure];
}
