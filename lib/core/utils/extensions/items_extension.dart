import 'package:mivent/features/cart/domain/entities/cart_item.dart';

extension ItemsListExt on List<CartItem> {
  double get total =>
      fold(0, (prev, e) => prev + (e.price + e.charge) * e.amount);
}
