import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/features/cart/domain/cart.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';

class HiveCart extends Cart<CartItem> {
  HiveCart(this.storeKey);
  final String storeKey;

  late final Box _hive;
  late final List<CartItem> _items;

  @override
  double get total =>
      _items.fold(0, (prev, e) => prev + (e.price + e.charge) * e.amount);

  @override
  init() async {
    _hive = await Hive.openBox(storeKey + ' cart');
    for (var e in _hive.keys) {
      _items.add(_hive.get(e));
    }
  }

  @override
  add(item) {
    if (item.isFree) return;
    var id = _items.indexOf(item);
    if (id == -1) {
      _items.add(item);
      _hive.add(item);
    } else if (!item.isFree) {
      _items[id].update(amount: _items[id].amount + item.amount);
      _items[id].save();
    }
  }

  @override
  remove(CartItem item) {
    if (super.remove(item)) {
      item.delete();
      return true;
    } else {
      return false;
    }
  }

  @override
  empty() {
    super.empty();
    _hive.clear();
  }
}
