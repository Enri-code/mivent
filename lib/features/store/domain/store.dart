import 'package:mivent/features/store/domain/storage.dart';
import 'package:mivent/global/domain/entities/item_mixin.dart';

abstract class IStore<T extends ItemMixin> extends IStorage<T> {
  IStore();

  List<String> get ids;

  bool contains(T item);
  put(T item);
  remove(T item);
}
