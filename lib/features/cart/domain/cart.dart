import 'package:mivent/features/cart/domain/entities/cart_item.dart';

abstract class ICart<T extends CartItem> {
  ICart();

  double get total;

  List<T> get items;

  add(T item, [int amount]);
  update(T item);

  remove(T item);

  empty();
}
