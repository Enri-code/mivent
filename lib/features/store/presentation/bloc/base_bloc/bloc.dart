import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mivent/core/utils/enums.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/storage.dart';
import 'package:mivent/features/store/domain/use_cases.dart';
import 'package:mivent/features/store/presentation/bloc/events_store.dart';

part 'event.dart';
part 'state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> with EventStore {
  StoreBloc(this._store) : super(StoreState.initial(_store)) {
    on<_EmitEvent>(_init);
    on<AddEvent>(_add);
    on<RemoveEvent>(_remove);

    _store.init().listen((_) => add(_EmitEvent()));
  }

  final IStore _store;

  void _init(_, Emitter<StoreState> emit) => emit(state);

  void _add(AddEvent event, Emitter<StoreState> emit) async {
    emit(state.copyWith(status: OperationStatus.loading));
    try {
      emit(state.copyWith(status: OperationStatus.success));
      await Add(_store).call(event.item);
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failed));
    }
  }

  void _remove(RemoveEvent event, Emitter<StoreState> emit) async {
    emit(state.copyWith(status: OperationStatus.loading));
    try {
      emit(state.copyWith(status: OperationStatus.success));
      await Remove(_store).call(event.item);
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failed));
    }
  }
}
