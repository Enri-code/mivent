part of 'bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends CartEvent {}

class AddEvent extends CartEvent {
  const AddEvent(this.ticket, {this.amount = 1});
  final Ticket ticket;
  final int amount;

  @override
  List<Object> get props => [ticket, amount];
}

class RemoveEvent extends CartEvent {
  const RemoveEvent(this.ticket);
  final Ticket ticket;

  @override
  List<Object> get props => [ticket];
}

class EmptyEvent extends CartEvent {}
