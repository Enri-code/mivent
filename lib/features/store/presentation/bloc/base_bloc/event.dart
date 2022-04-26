part of 'bloc.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class _EmitEvent extends StoreEvent {}

class AddEvent extends StoreEvent {
  const AddEvent(this.item);
  final ItemMixin item;

  @override
  List<Object> get props => [item];
}

class RemoveEvent extends StoreEvent {
  const RemoveEvent(this.item);
  final ItemMixin item;

  @override
  List<Object> get props => [item];
}
