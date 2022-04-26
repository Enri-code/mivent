import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mivent/features/cart/domain/entities/cart_item.dart';
import 'package:mivent/features/events/domain/entities/event.dart';

@HiveType(typeId: 1)
class Ticket extends CartItem {
  Ticket({
    int? id,
    required String name,
    required this.event,
    required double price,
    this.image,
    double charge = 0,
    int amount = 1,
    int? leftInStock,
  }) : super(
          id,
          name: name,
          price: price,
          charge: charge,
          amount: amount,
          leftInStock: leftInStock,
        );

  factory Ticket.unknown() => Ticket(id: null, name: '', price: 0, event: null);

  @HiveField(4)
  final Event? event;
  final ImageProvider<Object>? image;

}
