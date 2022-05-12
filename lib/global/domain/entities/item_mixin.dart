import 'package:mivent/core/utils/constants.dart';

mixin ItemMixin {
  String? get id;
  String get name;
}

mixin CartDataMixin {
  double get price;
  double get charge;
  int? get unitsLeft;

  bool get isFree => price == 0;
  bool get isAvailable => unitsLeft == null || unitsLeft! > 0;

  int get maxBuyable {
    var left = (unitsLeft ?? Constants.maxTicketUnitsPerPurchase)
        .clamp(0, Constants.maxTicketUnitsPerPurchase);
    if (isFree && left > 0) return 1;
    return left;
  }
}
