import 'package:mivent/core/constants.dart';

mixin ItemMixin {
  int? get id;
  String get name;
}

mixin CartDataMixin {
  double get price;
  double get charge;
  int? get leftInStock;

  bool get isFree => price == 0;
  bool get isAvailable => leftInStock == null || leftInStock! > 0;

  int get maxBuyable {
    var left = (leftInStock ?? Constants.maxTicketUnitsPerPurchase)
        .clamp(0, Constants.maxTicketUnitsPerPurchase);
    if (isFree && left > 0) return 1;
    return left;
  }

}
