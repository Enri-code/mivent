part of 'bloc.dart';

class StoreState extends Equatable {
  const StoreState(this.store, {required this.status});
  factory StoreState.initial(IStore _store) =>
      StoreState(_store, status: OperationStatus.loading);

  final IStore store;
  final OperationStatus status;

  StoreState copyWith({OperationStatus? status}) =>
      StoreState(store, status: status ?? this.status);

  @override
  List<Object?> get props => [store, status];
}
