import 'dart:async';
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/global/domain/entities/item_mixin.dart';
import 'package:mivent/features/events/domain/entities/date_range.dart';
import 'package:mivent/features/events/domain/entities/price_range.dart';

@HiveType(typeId: 0)
class Event extends HiveObject with ItemMixin {
  Event({
    required this.id,
    required this.name,
    required this.location,
    required this.dates,
    required this.attendersCount,
    this.imageGetter,
    this.attendersThumbsGetter = const [],
    bool? hasTicket,
    this.liked = false,
    this.prices = PriceRange.free,
  }) : _hasTicket = hasTicket;

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String location;
  @HiveField(3)
  final FutureOr<Uint8List?>? imageGetter;

  ///[Null] only means the data hasn't been gotten yet
  @HiveField(4)
  final DateRange? dates;
  @HiveField(5)
  final PriceRange? prices;
  @HiveField(6)
  bool liked;

  final bool? _hasTicket;
  final int attendersCount;
  final List<FutureOr<Uint8List?>> attendersThumbsGetter;

  bool get isFree => prices?.to == 0 && prices?.from == 0;
  bool get hasTicket => _hasTicket ?? !isFree;

  @override
  bool operator ==(dynamic other) => other is Event && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
