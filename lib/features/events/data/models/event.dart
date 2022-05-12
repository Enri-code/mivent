import 'dart:async';
import 'dart:typed_data';

import 'package:mivent/features/events/data/models/date_range.dart';
import 'package:mivent/features/events/data/models/price_range.dart';
import 'package:mivent/features/events/domain/entities/date_range.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/entities/price_range.dart';

class EventModel extends Event {
  EventModel._({
    required String id,
    required String name,
    required String location,
    required DateRange? dates,
    required int attendersCount,
    required List<FutureOr<Uint8List?>> attendersThumbsGetter,
    FutureOr<Uint8List?>? imageGetter,
    bool? hasTicket,
    PriceRange prices = PriceRange.free,
    bool isLiked = false,
  }) : super(
          id: id,
          name: name,
          location: location,
          dates: dates,
          prices: prices,
          imageGetter: imageGetter,
          hasTicket: hasTicket,
          attendersThumbsGetter: attendersThumbsGetter,
          attendersCount: attendersCount,
          liked: isLiked,
        );

  ///  hasTicket: map['has_ticket'],
  ///
  ///  dates: DateRangeModel.fromMap(map),
  ///
  ///  prices: PriceRangeModel.fromMap(map),
  ///
  ///  attendersCount: map['attenders_count']
  ///
  ///  imageGetter: map['image_future'] as FutureOr<Uint8List?>?
  ///
  ///  attendersThumbsGetter: ['attenders_futures'] as List<FutureOr<Uint8List?>>
  ///
  ///  isLiked: map['is_liked'] ?? false,
  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel._(
        id: map['id'],
        name: map['name'],
        location: map['location'],
        hasTicket: map['has_ticket'],
        dates: DateRangeModel.fromMap(map),
        prices: PriceRangeModel.fromMap(map),
        attendersCount: map['attenders_count'],
        imageGetter: map['image_future'] as FutureOr<Uint8List?>?,
        attendersThumbsGetter:
            map['attenders_futures'] as List<FutureOr<Uint8List?>>,
        isLiked: map['is_liked'] ?? false,
      );

  static Map<String, dynamic> infoToMap(Event event) =>
      {'id': event.id, 'name': event.name, 'location': event.location};
}
