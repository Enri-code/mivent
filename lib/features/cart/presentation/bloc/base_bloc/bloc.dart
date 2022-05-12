import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/core/utils/extensions/items_extension.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';
import 'package:mivent/features/cart/domain/repos/cart.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/cart/domain/use_cases.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';

part 'event.dart';
part 'state.dart';

class CartBloc extends Bloc<CartEvent, CartState> with TicketCartBloc {
  CartBloc(this._cart) : super(CartState.initial()) {
    on<AddItemEvent>(_add);
    on<UpdateItemEvent>(_update);
    on<RemoveItemEvent>(_remove);
    on<EmptyEvent>(_empty);
  }
  final ICart _cart;

  @override
  String get totalPrice => items.total.toCurrency(false);

  @override
  List<CartItem> get items => _cart.items;

  void _add(AddItemEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    try {
      AddItem(_cart).call(event.item, event.amount);
      emit(
        state.copyWith(status: OperationStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.minorFail));
    }
  }

  void _update(UpdateItemEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    try {
      if (event.item != null) UpdateItem(_cart).call(event.item!);
      emit(
        state.copyWith(status: OperationStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.minorFail));
    }
  }

  void _remove(RemoveItemEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    try {
      event.item.update(amount: 1);
      RemoveItem(_cart).call(event.item);
      emit(
        state.copyWith(status: OperationStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.minorFail));
    }
  }

  void _empty(EmptyEvent event, Emitter<CartState> emit) {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    try {
      EmptyCart(_cart).call();
      emit(state.copyWith(status: OperationStatus.success));
    } catch (e) {
      emit(state.copyWith(status: OperationStatus.minorFail));
    }
  }
}
