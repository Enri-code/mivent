import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mivent/models/date_range.dart';
import 'package:mivent/models/event.dart';

class SampleData {
  static final popularEventsPreview = [
    Event(
      name: 'House Party',
      location: 'Love Garden, Nsk',
      date: DateRange(DateTime(2022, 3, 15), DateTime(2023, 3, 12)),
      image: const AssetImage('../assets/images/guest.png'),
      liked: false,
    ),
    Event(
      name: 'Office Outing',
      location: 'Nsukka',
      date: DateRange(DateTime(2022, 4, 15), DateTime(2022, 6, 12)),
      liked: true,
    ),
    Event(
      name: 'Office Outing',
      location: 'Nsukka',
      date: DateRange(DateTime(2022, 4, 15)),
      image: const AssetImage('../assets/images/party_icons.jpg'),
      liked: true,
    ),
  ];
}
