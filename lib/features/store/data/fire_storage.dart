import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/initializers/fire_initializer.dart';
import 'package:mivent/features/auth/data/repos/fire_auth_repo.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/storage.dart';

class FirestoreStore<T extends ItemMixin> extends IStore<T> {
  FirestoreStore(this.key, {this.privateToUser = false});

  late final CollectionReference<Map<String, dynamic>> _collection;

  @override
  final String key;
  final bool privateToUser;

  @override
  Future<List<T>> get items async {
    throw UnimplementedError();
  }

  @override
  init() async {
    await FireInitializer.waiter;
    _collection = privateToUser
        ? FireAuth.userCollection.collection(key)
        : FirebaseFirestore.instance.collection(key);
  }

  @override
  Future putAll(Iterable<T> items) {
    throw UnimplementedError();
  }

  @override
  Future clear() {
    throw UnimplementedError();
  }

  @override
  bool contains(T item) {
    throw UnimplementedError();
  }

  @override
  Future put(T item) {
    throw UnimplementedError();
  }

  @override
  Future remove(T item) {
    throw UnimplementedError();
  }
}
