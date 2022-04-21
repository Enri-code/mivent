import 'package:hive/hive.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';

@HiveType(typeId: 0)
class CartItem extends HiveObject with ItemMixin {
  CartItem(
    this.id, {
    required this.name,
    required this.price,
    this.charge = 0,
    this.amount = 1,
    this.leftInStock,
  });

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
  int amount;

  @override
  double charge;
  @override
  int? leftInStock;

  @override
  bool operator ==(dynamic other) => other is CartItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  void update({int? amount}) {
    this.amount = amount ?? this.amount;
    save();
  }
}
