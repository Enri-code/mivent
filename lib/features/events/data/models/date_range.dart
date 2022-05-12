import 'package:mivent/features/events/domain/entities/date_range.dart';

///Don't store in database directly
class DateRangeModel extends DateRange {
  DateRangeModel._(DateTime from, [DateTime? to]) : super(from, to);

  factory DateRangeModel.fromMap(Map map) => DateRangeModel._(
        DateTime.fromMillisecondsSinceEpoch(map['start_time'], isUtc: true),
        map['end_time'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['end_time'], isUtc: true)
            : null,
      );
}
