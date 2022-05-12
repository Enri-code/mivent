import 'package:dartz/dartz.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';

abstract class IEventManager {
  const IEventManager();
  Future<Either<Failure, Event>> attend(Event event);
  Future<Either<Failure, Event>> cancelAttendance(Event event);

  Future<Either<Failure?, dynamic>> getTickets(List<Ticket> tickets);
  Future<Either<Failure, dynamic>> cancelTicket(OwnedTicket ticket,
      {bool requestRefund = false});
}
