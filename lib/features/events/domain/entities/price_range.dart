import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/core/constants.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';

@HiveType(typeId: 3)

///[to] should either be larger than [from] or 0
class PriceRange {
  const PriceRange([this.from, this.to = 0]);

  @HiveField(0)
  final num? from;
  @HiveField(1)
  final num to;

  static const free = PriceRange(0, 0);

  String? get range {
    if (from == null && to == 0) return null;

    var sign = Constants.currencySymbol;
    var _range =
        (from == 0 || from == null) ? 'FREE' : sign + from!.shortString;

    if (to == 0 || to == from) return _range;

    return _range + ' - ' + sign + to.shortString;
  }
}
