import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/events/domain/entities/event_section.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';

part 'remote_events_event.dart';
part 'remote_events_state.dart';

///TODO: use another method to display remote events
class GetRemoteEventsBloc extends Bloc<RemoteEventsEvent, RemoteEventsState> {
  GetRemoteEventsBloc([
    List<IEventSectionRepo> initialSectionProviders = const [],
  ]) : super(RemoteEventsState.initial(initialSectionProviders)) {
    on<AddSectionEvent>(_add);
    on<SectionErrorEvent>(_error);
    on<SectionSuccessEvent>(_success);

    initialSectionCount = initialSectionProviders.length;
  }
  late final int initialSectionCount;

  void _add(AddSectionEvent event, Emitter<RemoteEventsState> emit) {
    state.sections.add(event.data);
    emit(state.copyWith(
      status: OperationStatus.minorLoading,
      lastSectionId: state.sections.length - 1,
      lastSection: event.data,
    ));
  }

  void _success(
    SectionSuccessEvent event,
    Emitter<RemoteEventsState> emit,
  ) {
    emit(state.copyWith(
      status: OperationStatus.success,
      updateSection: event.data..status = OperationStatus.success,
      lastSectionId: null,
      lastSection: null,
    ));
  }

  void _error(SectionErrorEvent event, Emitter<RemoteEventsState> emit) {
    int? lastId = state.sections.lastIndexOf(event.data);
    if (lastId >= 0) {
      state.sections.removeAt(lastId);
    } else {
      lastId = null;
    }
    if (state.isCompleteFail) {
      emit(state.copyWith(
        status: OperationStatus.majorFail,
        lastSectionId: lastId,
        lastSection: event.data,
      ));
    } else {
      emit(state.copyWith(
        status: OperationStatus.minorFail,
        lastSectionId: lastId,
        lastSection: event.data,
      ));
    }
  }
}
