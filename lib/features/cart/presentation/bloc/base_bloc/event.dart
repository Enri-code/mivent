part of 'bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddItemEvent extends CartEvent {
  const AddItemEvent(this.item, {this.amount = 1});
  final CartItem item;
  final int amount;

  @override
  List<Object> get props => [item, amount];
}

class UpdateItemEvent extends CartEvent {
  const UpdateItemEvent([this.item]);
  final CartItem? item;

  @override
  List<Object?> get props => [item];
}

class RemoveItemEvent extends CartEvent {
  const RemoveItemEvent(this.item);
  final CartItem item;

  @override
  List<Object> get props => [item];
}

class EmptyEvent extends CartEvent {}
