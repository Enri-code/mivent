import 'package:mivent/features/cart/domain/cart.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';

class Add {
  final ICart _repo;
  const Add(this._repo);

  void call(CartItem item, int amount) => _repo.add(item, amount);
}

class Update {
  final ICart _repo;
  const Update(this._repo);

  void call(CartItem item) => _repo.update(item);
}

class Remove {
  final ICart _repo;
  const Remove(this._repo);

  call(CartItem item) => _repo.remove(item);
}

class Empty {
  final ICart _repo;
  const Empty(this._repo);

  call() => _repo.empty();
}
