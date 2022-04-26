import 'package:hive/hive.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';

class TicketAdapter extends TypeAdapter<Ticket> {
  @override
  final typeId = 1;

  @override
  Ticket read(BinaryReader reader) => Ticket(
        id: reader.read(),
        name: reader.read(),
        price: reader.read(),
        amount: reader.read(),
        event: reader.read(),
      );

  @override
  void write(BinaryWriter writer, Ticket obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.price)
      ..write(obj.amount)
      ..write(obj.event);
  }
}
