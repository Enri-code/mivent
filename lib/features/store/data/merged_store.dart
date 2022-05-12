import 'package:mivent/features/store/data/stores/mixins.dart';
import 'package:mivent/global/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/store.dart';
import 'package:mivent/features/store/domain/storage.dart';

class MergedStore<T extends ItemMixin> extends IStore<T>
    with AttendingEventsStore<T>, SavedEventsStore<T> {
  MergedStore({
    required IStore<T> localStore,
    required IStorage<T> remoteStore,
    //this.getRemoteData = false,
  })  : _localStore = localStore,
        _remoteStore = remoteStore;

  //final bool getRemoteData;
  final IStore<T> _localStore;
  final IStorage<T> _remoteStore;

  bool remoteIDsGotten = false;

  @override
  String? get key => null;

  @override
  List<String> get ids => _localStore.ids;

  @override
  List<T> get items => _localStore.items as List<T>;

  @override
  init() async {
    await _localStore.init();
    _remoteStore.putIds(items, store: false);
    _localStore.clear();
    for (var e in (await _remoteStore.items)) {
      _localStore.put(e);
    }
  }

  @override
  bool contains(T item) => _localStore.contains(item);

  @override
  put(T item) => _localStore.put(item);

  @override
  putIds(Iterable<T> items, {bool store = true}) =>
      _localStore.putIds(items, store: store);

  @override
  remove(T item) => _localStore.remove(item);

  @override
  removeIds(items, {store = true}) =>
      _localStore.removeIds(items, store: store);

  @override
  clear({store = true}) {
    _localStore.clear(store: store);
    _remoteStore.clear(store: store);
  }

  @override
  backup() async {
    _remoteStore.clear(store: false);
    await _remoteStore.putIds(items);
    print('store was backed up remotely to: users/${_remoteStore.key}');
  }

  @override
  getRemoteIDs() async {
    if (remoteIDsGotten) return;
    await _remoteStore.init();
    remoteIDsGotten = true;
    for (var e in (await _remoteStore.items)) {
      _localStore.put(e);
    }
  }
}
