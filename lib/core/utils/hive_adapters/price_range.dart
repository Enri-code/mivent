import 'package:hive/hive.dart';
import 'package:mivent/features/events/domain/entities/price_range.dart';

class PriceRangeAdapter extends TypeAdapter<PriceRange> {
  @override
  final typeId = 3;

  @override
  PriceRange read(BinaryReader reader) =>
      PriceRange(reader.read(), reader.read());

  @override
  void write(BinaryWriter writer, PriceRange obj) {
    writer
      ..write(obj.from)
      ..write(obj.to);
  }
}
