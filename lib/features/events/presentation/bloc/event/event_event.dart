part of 'event_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class AttendEvent extends EventsEvent {
  const AttendEvent(this.event);
  final Event event;
  @override
  List<Object> get props => [event];
}

class CancelAttendanceEvent extends EventsEvent {
  const CancelAttendanceEvent(this.event);
  final Event event;
  @override
  List<Object> get props => [event];
}

class GetTicketsEvent extends EventsEvent {
  const GetTicketsEvent(this.tickets);
  final List<Ticket> tickets;
  @override
  List<Object> get props => [tickets];
}

class CancelTicketEvent extends EventsEvent {
  const CancelTicketEvent(this.ticket);
  final OwnedTicket ticket;
  @override
  List<Object> get props => [ticket];
}
