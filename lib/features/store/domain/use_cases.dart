import 'package:mivent/global/domain/entities/item_mixin.dart';
import 'package:mivent/features/store/domain/store.dart';

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
