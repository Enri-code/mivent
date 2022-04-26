import 'package:hive_flutter/adapters.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/storage.dart';

class HiveStore<T extends ItemMixin> extends IStore<T> {
  HiveStore(this.key);

  @override
  final String key;

  Box<T>? _box;

  Map<int, T> _items = {};

  @override
  List<T> get items => _items.values.toList();

  @override
  init() async {
    _box = await Hive.openBox(key);
    for (var e in _items.values) {
      _box!.put(e.id, e);
    }
    _items = _box!.toMap().cast<int, T>();
  }

  @override
  put(T item) {
    _box?.put(item.id, item);
    _items.update(item.id!, (_) => item, ifAbsent: () => item);
  }

  @override
  putAll(items) {
    _items.addAll(Map.fromEntries(items.map((e) => MapEntry(e.id!, e))));
    for (var item in items) {
      _box?.put(item.id, item);
    }
  }

  @override
  void clear() {
    _box?.clear();
    _items.clear();
  }

  @override
  bool contains(item) => _items.values.contains(item);

  @override
  void remove(item) {
    _box?.delete(item.id);
    _items.remove(item.id);
  }
}
