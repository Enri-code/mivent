import 'dart:collection';

import 'package:mivent/features/cart/domain/cart.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/store/domain/storage.dart';

class Cart extends ICart<CartItem> {
  Cart(this._store) {
    _store.init();
  }
  final IStore<CartItem> _store;

  @override
  double get total => (_store.items as List)
      .fold(0, (prev, e) => prev + (e.price + e.charge) * e.amount);

  @override
  void add(item, [int amount = 1]) {
    if (!item.isFree) {
      if (_store.contains(item) as bool) {
        item.update(amount: item.amount + amount);
      } else {
        item.update(amount: amount);
      }
    }
    _store.put(item);
  }

  @override
  void update(item) => _store.put(item);

  @override
  remove(CartItem item) => _store.remove(item);

  @override
  void empty() => _store.clear();

  @override
  List<CartItem> get items =>
      UnmodifiableListView(_store.items as Iterable<CartItem>);
}
