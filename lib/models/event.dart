import 'package:flutter/material.dart';
import 'package:mivent/models/date_range.dart';

class Event {
  const Event({
    required this.name,
    required this.location,
    required this.date,
    required this.liked,
    this.image,
  });

  final String name, location;
  final DateRange date;
  final ImageProvider<Object>? image;
  final bool liked;
}

class EventDetail extends Event {
  const EventDetail({
    required String name,
    required String location,
    required DateRange date,
    required bool liked,
  }) : super(name: name, location: location, date: date, liked: liked);
}
