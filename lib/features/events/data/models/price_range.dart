import 'package:mivent/features/events/domain/entities/price_range.dart';

///Don't store in database directly
class PriceRangeModel extends PriceRange {
  PriceRangeModel._(num from, [num to = 0]) : super(from, to);

  factory PriceRangeModel.fromMap(Map map) =>
      PriceRangeModel._(map['start_price'], map['end_price'] ?? 0);
}
