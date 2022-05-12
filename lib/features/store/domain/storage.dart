import 'dart:async';

import 'package:mivent/global/domain/entities/item_mixin.dart';

abstract class IStorage<T extends ItemMixin> {
  IStorage();
  String? get key;
  get items;
  Future init();
  putIds(Iterable<T> items, {bool store = true});
  removeIds(Iterable<T> items, {bool store = true});
  clear({store = true});
}
