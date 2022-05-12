import 'dart:typed_data';

import 'dart:async';

import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';

class OwnedTicketModel extends OwnedTicket {
  OwnedTicketModel._({
    required String id,
    required String name,
    required FutureOr<Uint8List?>? imageGetter,
    required double price,
    required int amount,
    required String qrData,
    required String orderId,
    required Event event,
  }) : super(
          id: id,
          name: name,
          imageGetter: imageGetter,
          price: price,
          amount: amount,
          qrData: qrData,
          orderId: orderId,
          event: event,
        );

  factory OwnedTicketModel.withTicket(
    String id,
    Ticket ticket, {
    required String qrData,
    required String orderId,
  }) =>
      OwnedTicketModel._(
        id: id,
        name: ticket.name,
        price: ticket.price,
        amount: ticket.amount,
        imageGetter: ticket.imageGetter,
        event: ticket.event,
        qrData: qrData,
        orderId: orderId,
      );
}
