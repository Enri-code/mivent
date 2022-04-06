import 'package:intl/intl.dart';

class DateRange {
  const DateRange(this.from, [this.to]);
  final DateTime from;
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

  String _getDate(DateTime date) {
    if (_today.year > date.year) {
      return yearFormat.format(date);
    } else {
      var ordinal = _dayOrdinal(date.day);
      if (_today.month > date.month) {
        return monthFormat.format(date) + ordinal;
      } else {
        return date.day.toString() + ordinal;
      }
    }
  }

  String get fromDate => _getDate(from);
  String get fullDate =>
      to == null ? fromDate : fromDate + ' - ' + _getDate(to!);
}
