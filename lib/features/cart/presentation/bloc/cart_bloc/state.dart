part of 'bloc.dart';

enum CartOperationStatus { success, failed, loading }

class CartState extends Equatable {
  final List<ItemMixin> items;
  final CartOperationStatus status;
  const CartState({required this.status, this.items = const []});

  factory CartState.initial() =>
      const CartState(status: CartOperationStatus.loading);

  CartState copyWith({CartOperationStatus? status, List<ItemMixin>? items}) =>
      CartState(
        status: status ?? this.status,
        items: items ?? this.items,
      );

  @override
  List<Object?> get props => [status, items];
}
