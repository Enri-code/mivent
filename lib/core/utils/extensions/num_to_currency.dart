import 'package:mivent/core/constants.dart';
import 'package:mivent/core/utils/extensions/string.dart';

extension NumExt on num {
  String get shortString {
    var newNumber = this;
    var suffix = '';
    if (this >= 1000000000) {
      newNumber /= 1000000000;
      suffix = 'B';
    }
    if (this >= 1000000) {
      newNumber /= 1000000;
      suffix = 'M';
    }
    if (this >= 1000) {
      newNumber /= 1000;
      suffix = 'K';
    }
    return newNumber.toStringAsFixed(1).trimmedTrailingZeros + suffix;
  }

  String toCurrency([removeTrailingZeros = true]) {
    String currency = Constants.currencyFormatter.format(this);
    if (removeTrailingZeros) {
      currency = currency.replaceAll(StringExt.trailingZeroFilter, '');
    }
    return currency;
  }

  String get nairaString => this == 0 ? 'FREE' : toCurrency();
}
