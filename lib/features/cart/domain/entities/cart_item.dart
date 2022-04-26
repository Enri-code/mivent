import 'package:hive/hive.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';

class CartItem extends HiveObject with ItemMixin, CartDataMixin {
  CartItem(
    this.id, {
    required this.name,
    required this.price,
    this.charge = 0,
    int amount = 1,
    this.leftInStock,
  }) : _amount = amount;

  @override
  @HiveField(0)
  final int? id;
  @override
  @HiveField(1)
  String name;
  @override
  @HiveField(2)
  double price;

  @HiveField(3)
  int _amount;

  @override
  double charge;
  @override
  int? leftInStock;

  @override
  bool operator ==(dynamic other) => other is CartItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  int get amount => _amount;
  int get amountBuyable => maxBuyable - (isFree ? 0 : _amount);

  void update({int? amount}) {
    _amount = amount ?? this.amount;
  }
}
