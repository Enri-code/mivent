import 'dart:collection';

import 'package:mivent/core/utils/extensions/items_extension.dart';
import 'package:mivent/features/cart/domain/repos/cart.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/store/domain/store.dart';

class Cart extends ICart {
  Cart(this._store) {
    _store.init();
  }

  final IStore<CartItem> _store;

  @override
  final double chargeMultiplier = 0.015, additionalCharge = 100;

  @override
  List<CartItem> get items =>
      UnmodifiableListView(_store.items as List<CartItem>);

  @override
  double get total => (_store.items as List<CartItem>).total;

  @override
  void add(CartItem item, [int amount = 1]) {
    if (!item.isFree) {
      if (_store.contains(item)) {
        item.update(amount: item.amount + amount);
      } else {
        item.update(amount: amount);
      }
    }
    _store.put(item);
  }

  @override
  void update(CartItem item) => _store.put(item);

  @override
  remove(CartItem item) => _store.remove(item);

  @override
  void empty() => _store.clear();
}
