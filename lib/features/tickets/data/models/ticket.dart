import 'dart:async';
import 'dart:typed_data';

import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';

class TicketModel extends Ticket {
  TicketModel._({
    required String? id,
    required String name,
    required double price,
    required Event event,
    FutureOr<Uint8List?>? imageGetter,
    int? unitsLeft,
    double charge = 0,
    int amount = 1,
  }) : super(
          id: id,
          name: name,
          event: event,
          price: price,
          amount: amount,
          imageGetter: imageGetter,
          charge: charge,
          unitsLeft: unitsLeft,
        );

  ///id: map['id'],
  ///
  ///name: map['name'],
  ///
  ///price: (map['price'] as num).toDouble(),
  ///
  ///event: map['event'],
  ///
  ///imageGetter: map['image_future'] as FutureOr<Uint8List?>?,
  ///
  ///unitsLeft: map['units_left'],
  factory TicketModel.fromMap(Map<String, dynamic> map) => TicketModel._(
        id: map['id'],
        name: map['name'],
        price: (map['price'] as num).toDouble(),
        event: map['event'],
        imageGetter: map['image_future'] as FutureOr<Uint8List?>?,
        unitsLeft: map['units_left'],
        charge: map['charge'] ?? 0,
      );

  static Map<String, dynamic> infoToMap(Ticket ticket) => {
        'id': ticket.id,
        'name': ticket.name,
        'price': ticket.price,
        'amount': ticket.amount,
      };
}
