import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/cart/presentation/bloc/base_bloc/bloc.dart';

mixin TicketCartBloc on Bloc<CartEvent, CartState> {
  String get totalPrice;
  List<CartItem> get items;
}
