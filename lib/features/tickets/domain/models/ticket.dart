import 'package:flutter/cupertino.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/events/domain/models/event.dart';

class Ticket with ItemMixin {
  Ticket({
    this.id,
    required this.name,
    required this.event,
    this.image,
    required this.price,
    this.charge = 0,
    this.leftInStock,
  });

  static get unknown => Ticket(id: null, name: '', price: 0, event: null);

  final Event? event;
  final ImageProvider<Object>? image;
  @override
  final String name;
  @override
  final int? id;
  @override
  final double price;
  @override
  final double charge;
  @override
  final int? leftInStock;
}
