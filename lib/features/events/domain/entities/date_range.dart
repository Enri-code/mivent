import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

@HiveType(typeId: 2)
class DateRange {
  const DateRange(this.from, [this.to]);
  @HiveField(0)
  final DateTime from;
  @HiveField(1)
  final DateTime? to;

  static final DateTime _today = DateTime.now();
  static final DateFormat monthFormat = DateFormat('MMM d'),
      yearFormat = DateFormat('MMM d, yyyy');

  Duration get dateLength => to?.difference(from) ?? const Duration();

  String _dayOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getShortDate(DateTime date, [DateTime? from]) {
    from ??= _today;
    if (from.year < date.year) return fromDate;

    var ordinal = _dayOrdinal(date.day);
    if (from.month < date.month) return monthFormat.format(date) + ordinal;
    return 'This ' + date.day.toString() + ordinal;
  }

  String get fromDate => yearFormat.format(from);

  String get fromDateShort => _getShortDate(from);

  String get range {
    var _date = fromDateShort;
    if (to != null) _date += '  --  ' + _getShortDate(to!);
    return _date;
  }

  /* String get fullDate =>
      to == null ? fromDate : fromDate + ' - ' + _getDate(to!);
 */
}
