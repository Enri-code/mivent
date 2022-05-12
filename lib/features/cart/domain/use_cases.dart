import 'package:mivent/features/cart/domain/repos/cart.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';

class AddItem {
  final ICart _repo;
  const AddItem(this._repo);

  void call(CartItem item, int amount) => _repo.add(item, amount);
}

class UpdateItem {
  final ICart _repo;
  const UpdateItem(this._repo);

  void call(CartItem item) => _repo.update(item);
}

class RemoveItem {
  final ICart _repo;
  const RemoveItem(this._repo);

  call(CartItem item) => _repo.remove(item);
}

class EmptyCart {
  final ICart _repo;
  const EmptyCart(this._repo);

  call() => _repo.empty();
}
