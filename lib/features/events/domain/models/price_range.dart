import 'package:mivent/core/constants.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';

class PriceRange {
  ///[to] should either be larger than [from] or 0
  const PriceRange([this.from, this.to = 0]);
  final num? from;
  final num to;

  static const free = PriceRange(0, 0);

  String? get range {
    if (from == null && to == 0) return null;

    var sign = Constants.currencySymbol;
    var _range =
        (from == 0 || from == null) ? 'FREE' : sign + from!.shortString;

    if (to == 0 || to == from) return _range;

    return _range + ' - ' + sign + to.shortString;

    /* return Functions.convertToCurrency(from!) +
        ' - ' +
        Functions.convertToCurrency(to!); */
  }
}
