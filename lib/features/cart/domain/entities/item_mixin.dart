import 'dart:math';

mixin ItemMixin {
  int? get id;
  String get name;
  double get price;
  double get charge;
  int? get leftInStock;

  bool get isFree => price == 0;
  bool get soldOut => (leftInStock ?? 2) < 1;
  int get buyable => max(0, min(10, leftInStock ?? 10));
}
