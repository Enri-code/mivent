import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mivent/core/utils/enums.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';
import 'package:mivent/features/cart/domain/cart.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/cart/domain/use_cases.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';

part 'event.dart';
part 'state.dart';

class CartBloc extends Bloc<CartEvent, CartState> with TicketCartBloc {
  CartBloc(this._cart) : super(CartState.initial()) {
    on<AddEvent>(_add);
    on<UpdateEvent>(_update);
    on<RemoveEvent>(_remove);
    on<EmptyEvent>(_empty);
  }
  final ICart _cart;

  @override
  String get totalPrice => _cart.total.toCurrency(false);

  @override
  List<CartItem> get items => _cart.items;

  void _add(AddEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.loading));
    try {
      Add(_cart).call(event.ticket, event.amount);
      emit(
        state.copyWith(status: OperationStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failed));
      rethrow;
    }
  }

  void _update(UpdateEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.loading));
    try {
      Update(_cart).call(event.ticket);
      emit(
        state.copyWith(status: OperationStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failed));
      rethrow;
    }
  }

  void _remove(RemoveEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.loading));
    try {
      event.ticket.update(amount: 1);
      Remove(_cart).call(event.ticket);
      emit(
        state.copyWith(status: OperationStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failed));
      rethrow;
    }
  }

  void _empty(EmptyEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.loading));
    try {
      Empty(_cart).call();
      emit(state.copyWith(status: OperationStatus.success));
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.failed));
      rethrow;
    }
  }
}
