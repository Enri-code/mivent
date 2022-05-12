import 'dart:collection';

import 'package:hive_flutter/adapters.dart';
import 'package:mivent/global/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/store.dart';

class HiveStore<T extends ItemMixin> extends IStore<T> {
  HiveStore(this.key, {bool selfInit = true}) {
    if (selfInit) init();
  }

  @override
  final String key;

  Box? _box;

  final Set<String> _ids = {};
  final Map<String, T> _items = {};

  @override
  List<String> get ids => UnmodifiableListView(items.map((e) => e.id!));
  //UnmodifiableListView(_box?.values.cast<T>().map((e) => e.id!) ?? _ids);

  @override
  List<T> get items =>
      UnmodifiableListView(_box?.values.cast<T>() ?? _items.values);

  @override
  Future init() async {
    _box ??= await Hive.openBox(key);
    for (var e in _items.values) {
      _box!.put(e.id, e);
    }
    _items.clear();
    if (_ids.isNotEmpty) {
      _box?.put('ids', _ids);
      _ids.clear();
    }
  }

  @override
  put(T item) =>
      _box?.put(item.id, item) ??
      _items.update(item.id!, (_) => item, ifAbsent: () => item);

  @override
  putIds(items, {store = true}) {
    var ids = items.map((e) => e.id!).toSet();
    if (store && _box != null) {
      _box!.put('ids', ids);
    } else {
      _ids.addAll(ids);
    }
  }

  @override
  bool contains(item) => _box?.values.contains(item) ?? false;

  @override
  void remove(item) => _box?.delete(item.id) ?? _items.remove(item);

  @override
  Future removeIds(items, {store = true}) async {
    var ids = items.map((e) => e.id!);
    return _box?.deleteAll(ids) ?? _ids.removeAll(ids);
  }

  @override
  void clear({store = true}) {
    _ids.clear();
    _items.clear();
    if (store) _box?.clear();
  }
}
