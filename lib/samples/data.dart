import 'package:flutter/cupertino.dart';
import 'package:mivent/features/events/domain/entities/date_range.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/entities/price_range.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';

class SampleData {
  static final eventsPreview = [
    Event(
      id: 2,
      name: 'House Party with DJ Midnight',
      location: 'Love Garden, Nsk',
      dates: DateRange(DateTime(2022, 4, 25), DateTime(2023, 3, 12)),
      prices: const PriceRange(null, 30000),
      image: const AssetImage('assets/samples/party_image.jpg'),
      hasTicket: true,
    ),
    Event(
      id: 5,
      name: 'Office Outing',
      location: 'Nsukka',
      dates: DateRange(DateTime(2022, 5, 18), DateTime(2022, 6, 12)),
      prices: const PriceRange(5400),
      hasTicket: true,
    ),
    Event(
      id: 3,
      name: 'Live Music Sundays (LMS)',
      location: 'Nsukka',
      dates: DateRange(DateTime(2023, 4, 2)),
      image: const AssetImage('assets/samples/party_icons.jpg'),
    ),
  ];

  static final tickets = [
    Ticket(
      id: 0,
      price: 0,
      name: 'Free Ticket',
      event: eventsPreview[0],
    ),
    Ticket(
      id: 1,
      price: 1000,
      name: '1k Ticket',
      leftInStock: 1000,
      event: eventsPreview[0],
    ),
    Ticket(
      id: 2,
      price: 30000,
      name: '30k Ticket',
      leftInStock: 4,
      event: eventsPreview[0],
    ),
    Ticket(
      id: 3,
      price: 5400,
      name: '',
      event: eventsPreview[1],
    ),
  ];
}
