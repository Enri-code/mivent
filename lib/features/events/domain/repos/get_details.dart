import 'package:dartz/dartz.dart';
import 'package:mivent/features/events/domain/entities/details.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';

abstract class IEventDetails {
  Future<Either<void, EventDetail?>> getDetails(String id);
  Future<Either<void, List<Ticket>>> getRemoteEventTickets(Event event);
}
