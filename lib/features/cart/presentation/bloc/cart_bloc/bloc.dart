import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mivent/features/cart/data/model/cart_item.dart';
import 'package:mivent/features/cart/domain/cart.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';

part 'event.dart';
part 'state.dart';

class CartBloc extends Bloc<CartEvent, CartState> with TicketCartBloc {
  CartBloc(this._cart) : super(CartState.initial()) {
    on<InitEvent>((_, __) => _cart.init());
    on<AddEvent>(_add);
    on<RemoveEvent>(_remove);
    on<EmptyEvent>(_empty);
  }
  final Cart _cart;

  void _add(AddEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartOperationStatus.loading));
    try {
      _cart.add(
        CartItemModel.fromItem(item: event.ticket, amount: event.amount),
      );
      emit(
        state.copyWith(status: CartOperationStatus.success, items: _cart.items),
      );
    } catch (e) {
      emit(state.copyWith(status: CartOperationStatus.failed));
    }
  }

  void _remove(RemoveEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartOperationStatus.loading));
    try {
      _cart.remove(event.ticket);
      emit(
        state.copyWith(status: CartOperationStatus.success, items: _cart.items),
      );
    } catch (e) {
      emit(state.copyWith(status: CartOperationStatus.failed));
    }
  }

  void _empty(EmptyEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: CartOperationStatus.loading));
    try {
      _cart.empty();
      emit(state.copyWith(status: CartOperationStatus.success, items: []));
    } catch (e) {
      emit(state.copyWith(status: CartOperationStatus.failed));
    }
  }
}
