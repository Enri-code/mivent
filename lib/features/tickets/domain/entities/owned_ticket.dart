import 'dart:async';
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';

class OwnedTicket extends Ticket {
  OwnedTicket({
    required String id,
    required String name,
    required double price,
    required int amount,
    required Event event,
    required this.orderId,
    required this.qrData,
    FutureOr<Uint8List?>? imageGetter,
  }) : super(
          id: id,
          name: name,
          event: event,
          price: price,
          imageGetter: imageGetter,
          amount: amount,
        );
  @HiveField(6)
  final String qrData;
  @HiveField(7)
  final String orderId;
}
