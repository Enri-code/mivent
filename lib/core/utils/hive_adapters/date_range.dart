import 'package:hive/hive.dart';
import 'package:mivent/features/events/domain/entities/date_range.dart';

class DateRangeAdapter extends TypeAdapter<DateRange> {
  @override
  final typeId = 2;

  @override
  DateRange read(BinaryReader reader) =>
      DateRange(reader.read(), reader.read());

  @override
  void write(BinaryWriter writer, DateRange obj) {
    writer
      ..write(obj.from)
      ..write(obj.to);
  }
}
