import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';

class CartItemModel extends CartItem {
  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'charge': charge,
        'amount_left': leftInStock,
      };

  CartItemModel.fromMap(Map<String, Object?> map)
      : super(map['id'] as int?,
            name: map['name'] as String,
            price: map['price'] as double,
            charge: map['charge'] as double,
            leftInStock: map['amount_left'] as int?);

  CartItemModel.fromItem({required ItemMixin item, int? amount})
      : super(item.id,
            name: item.name,
            price: item.price,
            charge: item.charge,
            amount: amount ?? 1,
            leftInStock: item.leftInStock);
}
