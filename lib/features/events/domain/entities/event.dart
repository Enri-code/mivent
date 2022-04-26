import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mivent/features/cart/domain/entities/item_mixin.dart';
import 'package:mivent/features/events/domain/entities/date_range.dart';
import 'package:mivent/features/events/domain/entities/price_range.dart';

@HiveType(typeId: 0)
class Event extends HiveObject with ItemMixin {
  Event({
    required this.id,
    required this.name,
    required this.location,
    required this.dates,
    this.image,
    bool? hasTicket,
    this.liked = false,
    this.prices = PriceRange.free,
  }) : _hasTicket = hasTicket;

  @override
  @HiveField(0)
  final int? id;
  @override
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String location;

  ///[Null] only means the data hasn't been gotten yet
  @HiveField(3)
  final DateRange? dates;
  @HiveField(4)
  final PriceRange? prices;
  @HiveField(5)
  bool liked;

  final ImageProvider<Object>? image;

  final bool? _hasTicket;

  bool get isFree => prices?.to == 0 && prices?.from == 0;
  bool get hasTicket => _hasTicket ?? !isFree;

  @override
  bool operator ==(dynamic other) => other is Event && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class EventDetail extends Event {
  EventDetail(
    Event eventData, {
    this.description = '',
    this.mapPosition,
  }) : super(
          id: eventData.id,
          liked: eventData.liked,
          name: eventData.name,
          hasTicket: eventData.hasTicket,
          image: eventData.image,
          location: eventData.location,
          dates: eventData.dates,
          prices: eventData.prices,
        );

  LatLng? mapPosition;
  String description;
}
