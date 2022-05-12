import 'package:mivent/features/cart/domain/entities/cart_item.dart';

abstract class ICart {
  double get total;
  double get chargeMultiplier;
  double get additionalCharge;

  void add(CartItem item, [int amount = 1]);

  void update(CartItem item);

  remove(CartItem item);

  void empty();

  List<CartItem> get items;
}
