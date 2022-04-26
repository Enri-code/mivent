part of 'bloc.dart';

class CartState extends Equatable {
  final OperationStatus status;
  const CartState._({required this.status});

  factory CartState.initial() =>
      const CartState._(status: OperationStatus.loading);

  CartState copyWith({OperationStatus? status}) =>
      CartState._(status: status ?? this.status);
  @override
  List<Object?> get props => [status];
}
