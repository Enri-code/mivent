import 'package:hive/hive.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';

class CartItemsAdapter extends TypeAdapter<CartItem> {
  @override
  final typeId = 0;

  @override
  CartItem read(BinaryReader reader) => CartItem(
        reader.read(),
        name: reader.read(),
        price: reader.read(),
        amount: reader.read(),
      );

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.price)
      ..write(obj.amount);
  }
}
