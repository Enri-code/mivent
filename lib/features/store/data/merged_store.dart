import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/storage.dart';

class MergedStore<T extends ItemMixin> extends IStore<T> {
  MergedStore(this._localStore, {IStore? remoteStore})
      : _remoteStore = remoteStore;

  @override
  String get key => '';

  final IStore _localStore;
  final IStore? _remoteStore;

  @override
  List<T> get items => _localStore.items as List<T>;

  @override
  init() async* {
    yield StoreInitState.started;
    await _localStore.init();
    yield StoreInitState.localDone;
    await _remoteStore?.init();
    for (var e in await _remoteStore!.items) {
      _localStore.put(e);
    }
    for (var e in await _localStore.items) {
      await _remoteStore!.put(e);
    }
    yield StoreInitState.remoteDone;
  }

  @override
  bool contains(T item) => _localStore.contains(item) as bool;

  @override
  put(T item) {
    _localStore.put(item);
    _remoteStore?.put(item);
  }

  @override
  putAll(Iterable<T> items) {
    _localStore.putAll(items);
    _remoteStore?.putAll(items);
  }

  @override
  remove(T item) {
    _localStore.remove(item);
    _remoteStore?.remove(item);
  }

  @override
  clear() {
    _localStore.clear();
    _remoteStore?.clear();
  }
}
