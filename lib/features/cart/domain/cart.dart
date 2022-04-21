import 'dart:collection';

import 'package:mivent/features/cart/domain/entities/item_mixin.dart';

abstract class Cart<T extends ItemMixin> {
  Cart();

  List<T> get _items;

  double get total;

  List<T> get items => UnmodifiableListView(_items);

  init();

  add(T item);

  bool remove(T item) => _items.remove(item);

  empty() => _items.clear();
}
