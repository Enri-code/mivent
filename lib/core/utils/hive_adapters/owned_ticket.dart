import 'package:hive/hive.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';

class OwnedTicketAdapter extends TypeAdapter<OwnedTicket> {
  @override
  final typeId = 5;

  @override
  OwnedTicket read(BinaryReader reader) => OwnedTicket(
        id: reader.read(),
        name: reader.read(),
        price: reader.read(),
        amount: reader.read(),
        event: reader.read(),
        imageGetter: reader.read(),
        qrData: reader.read(),
        orderId: reader.read(),
      );

  @override
  void write(BinaryWriter writer, OwnedTicket obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.price)
      ..write(obj.amount)
      ..write(obj.event)
      ..write(obj.imageGetter)
      ..write(obj.qrData)
      ..write(obj.orderId);
  }
}
