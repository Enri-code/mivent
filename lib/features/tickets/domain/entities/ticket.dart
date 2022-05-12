import 'dart:async';
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/events/domain/entities/event.dart';

@HiveType(typeId: 1)
class Ticket extends CartItem {
  Ticket({
    String? id,
    required String name,
    required double price,
    this.imageGetter,
    required this.event,
    double charge = 0,
    int amount = 1,
    int? unitsLeft,
  }) : super(
          id,
          name: name,
          price: price,
          charge: charge,
          amount: amount,
          unitsLeft: unitsLeft,
        );

  @HiveField(4)
  final Event event;
  @HiveField(5)
  final FutureOr<Uint8List?>? imageGetter;
}
