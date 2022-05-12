import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/events.dart';
import 'package:mivent/features/store/data/stores/mixins.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(this.read, {required this.eventMan}) : super(const EventsState()) {
    on<AttendEvent>(_attend);
    on<CancelAttendanceEvent>(_cancelAttendance);
    on<GetTicketsEvent>(_getTickets);
    on<CancelTicketEvent>(_cancelTicket);
  }
  final Reader read;
  final IEventManager eventMan;

  Future backup() => read<SavedEventsStore>().backup();

  bool isUserAttending(Event event) =>
      read<AttendingEventsStore>().contains(event);

  _attend(AttendEvent event, Emitter<EventsState> emit) async {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    var res = await eventMan.attend(event.event);
    res.fold(
      (l) => emit(
        state.copyWith(status: OperationStatus.minorFail, failure: l),
      ),
      (r) => emit(state.copyWith(status: OperationStatus.success)),
    );
  }

  _cancelAttendance(
    CancelAttendanceEvent event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    var res = await eventMan.cancelAttendance(event.event);
    res.fold(
      (l) => emit(
        state.copyWith(status: OperationStatus.minorFail, failure: l),
      ),
      (r) => emit(state.copyWith(status: OperationStatus.success)),
    );
  }

  _getTickets(GetTicketsEvent event, Emitter<EventsState> emit) async {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    var res = await eventMan.getTickets(event.tickets);
    res.fold(
      (l) {
        if (l == null) return;
        emit(state.copyWith(
          status: OperationStatus.minorFail,
          failure: l,
        ));
      },
      (r) => emit(state.copyWith(status: OperationStatus.success)),
    );
  }

  _cancelTicket(CancelTicketEvent event, Emitter<EventsState> emit) async {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    var res = await eventMan.cancelTicket(event.ticket);
    res.fold(
      (l) {},
      (r) {},
    );
  }
}
