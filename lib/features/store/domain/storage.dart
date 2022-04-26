import 'dart:async';

import 'package:mivent/features/cart/domain/entities/item_mixin.dart';

enum StoreInitState { started, localDone, remoteDone }

abstract class IStore<T extends ItemMixin> {
  IStore();

  String get key;

  FutureOr<List<T>> get items;

  Stream<StoreInitState> init();

  FutureOr<bool> contains(T item);

  put(T item);

  remove(T item);

  putAll(Iterable<T> items);

  clear();
}
