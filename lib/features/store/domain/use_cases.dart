import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/storage.dart';

class Add {
  final IStore _repo;
  const Add(this._repo);

  call(ItemMixin item) => _repo.put(item);
}

class Remove {
  final IStore _repo;
  const Remove(this._repo);

  call(ItemMixin item) => _repo.remove(item);
}
