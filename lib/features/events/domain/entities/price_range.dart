import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/core/utils/constants.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';

@HiveType(typeId: 3)

///[to] should either be larger than [from] or 0
class PriceRange {
  const PriceRange(this.from, [this.to = 0]);

  @HiveField(0)
  final num from;
  @HiveField(1)
  final num to;

  static const free = PriceRange(0, 0);

  String get range {
    var sign = Constants.currencySymbol;
    var range =
        (from == 0) ? 'FREE' : sign + from.shortString;

    if (to == 0 || to == from) return range;
    return '$range - $sign${to.shortString}';
  }
}
