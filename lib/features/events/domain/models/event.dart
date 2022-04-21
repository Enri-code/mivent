import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mivent/features/events/domain/models/date_range.dart';
import 'package:mivent/features/events/domain/models/price_range.dart';

class Event {
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

  final int? id;
  final String name, location;
  final ImageProvider<Object>? image;

  ///[Null] only means the data hasn't been gotten yet
  final DateRange? dates;
  final PriceRange? prices;
  final bool? _hasTicket;

  bool liked;
  bool get isFree => prices?.to == 0 && prices?.from == 0;
  bool get hasTicket => _hasTicket ?? !isFree;
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
