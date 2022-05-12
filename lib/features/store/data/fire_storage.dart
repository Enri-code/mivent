import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/features/auth/data/repos/fire_auth_repo.dart';
import 'package:mivent/features/store/domain/storage.dart';
import 'package:mivent/global/domain/entities/item_mixin.dart';

class FireStorage<F extends ItemMixin, T extends Map> extends IStorage<F> {
  FireStorage(
    this.key, {
    required this.fromConverter,
    required this.querySource,
    this.modifier,
    this.autoUpdate = false,
    bool selfInit = false,
  }) {
    if (selfInit) init();
  }

  final bool autoUpdate;
  final Future<Query<T>> Function() querySource;
  final Future<Iterable<T>> Function(Iterable<T>)? modifier;
  final FutureOr<F> Function(T map) fromConverter;

  final Set<String> _ids = {};

  @override
  final String key;

  @override
  Future<List<F>> get items async {
    if (_ids.isEmpty) return [];
    var query = (await querySource())
        .where(FieldPath.documentId, whereIn: _ids.toList());
    var data = await query.get();
    if (data.docs.isEmpty) return [];
    Iterable<T> docs = data.docs.map((e) => e.data()..['id'] = e.id);
    return [
      for (var e in await modifier?.call(docs) ?? docs) await fromConverter(e)
    ];
  }

  @override
  Future init() async {
    late List<String> data;
    try {
      var userDoc = await (await FireAuth.userDoc).get();
      data = (userDoc.data()?[key] as List?)?.cast<String>() ?? [];
    } catch (e, s) {
      print(e);
      print(s);
      data = [];
    }
    _ids.addAll(data);
  }

  @override
  clear({store = true}) async {
    _ids.clear();
    if (store) (await FireAuth.userDoc).update({key: []});
  }

  @override
  Future putIds(items, {store = true}) async {
    _ids.addAll(items.map((e) => e.id!));
    if (store || autoUpdate) {
      await (await FireAuth.userDoc).set({key: _ids.toList()});
    }
  }

  @override
  Future removeIds(items, {store = true}) async {
    _ids.removeAll(items.map((e) => e.id!));
    if (store || autoUpdate) {
      await (await FireAuth.userDoc).update({key: _ids.toList()});
    }
  }
}
