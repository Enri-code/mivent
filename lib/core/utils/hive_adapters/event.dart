import 'package:hive/hive.dart';
import 'package:mivent/features/events/domain/entities/event.dart';

class EventAdapter extends TypeAdapter<Event> {
  @override
  final typeId = 0;

  @override
  Event read(BinaryReader reader) {
    return Event(
      id: reader.read(),
      name: reader.read(),
      location: reader.read(),
      dates: reader.read(),
      prices: reader.read(),
      liked: reader.read(),
      attendersCount: 0,
      imageGetter: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) async {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.location)
      ..write(obj.dates)
      ..write(obj.prices)
      ..write(obj.liked)
      ..write(await obj.imageGetter);
  }
}
