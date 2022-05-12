import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/core/utils/extensions/items_extension.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/encryptor/data/models/key.dart';
import 'package:mivent/features/encryptor/domain/encryptor.dart';
import 'package:mivent/features/events/data/models/event.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/failure_causes.dart';
import 'package:mivent/features/events/domain/repos/events.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';
import 'package:mivent/features/store/data/merged_store.dart';
import 'package:mivent/features/store/data/stores/mixins.dart';
import 'package:mivent/features/tickets/data/models/owned_ticket.dart';
import 'package:mivent/features/tickets/data/models/ticket.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';
import 'package:mivent/features/transactions/domain/entities/pay_data.dart';
import 'package:mivent/features/transactions/domain/repos/manager.dart';

class FireEventManager extends IEventManager {
  FireEventManager(this._read);
  final Reader _read;

  FirebaseFirestore get store => FirebaseFirestore.instance;

  Future _addIds(Event event, String userId,
      {bool ignoreErrors = false}) async {
    var attendingEventsStore = _read<AttendingEventsStore>();
    attendingEventsStore.putIds([event]);
    await FireSetup.waitForInit;
    await Future.wait(<Future>[
      store.collection(FireConstants.usersCollName).doc(userId).update({
        'attending_events': FieldValue.arrayUnion([event.id])
      }),
      _read<EventsBloc>().backup(),
    ], eagerError: !ignoreErrors);
  }

  Future _removeIds(Event event, String userId,
      {bool ignoreErrors = false}) async {
    var attendingEventsStore = _read<AttendingEventsStore>();
    attendingEventsStore.removeIds([event]);
    await FireSetup.waitForInit;
    await Future.wait(<Future>[
      store.collection(FireConstants.usersCollName).doc(userId).update({
        'attending_events': FieldValue.arrayRemove([event.id])
      }),
      _read<EventsBloc>().backup(),
    ], eagerError: !ignoreErrors);
  }

  @override
  Future<Either<Failure, Event>> attend(Event event) async {
    var user = _read<AuthBloc>().state.user;
    if (user == null) {
      return const Left(
        Failure(message: 'You need to be logged in to attend events'),
      );
    }
    try {
      await _addIds(event, user.id!);
      Map<String, dynamic> newEventMap = {};

      await FireSetup.waitForInit;
      await store.runTransaction((transaction) async {
        var docRef =
            store.collection(FireConstants.publicEventsCollName).doc(event.id);
        var doc = await transaction.get(docRef);
        newEventMap = doc.data()!..['id'] = doc.id;
        var attenders = (newEventMap['attenders_preview'] as List);
        bool hasUserInAttenders = attenders.contains(user.id);

        if (!hasUserInAttenders) {
          attenders.insert(0, user.id!);
          if (attenders.length > 10) {
            attenders.removeRange(10, attenders.length);
          }
          newEventMap['attenders_preview'] = attenders;
        }
        transaction.update(docRef, {
          if (!hasUserInAttenders) 'attenders_preview': attenders,
          'attenders_count': FieldValue.increment(1)
        });
      });

      newEventMap = FireStoreHelper.fromFirestoreConverter(newEventMap);
      return Right(EventModel.fromMap(newEventMap));
    } catch (e) {
      _removeIds(event, user.id!, ignoreErrors: true);
      return const Left(Failure(/* cause: AttendFailure() */));
    }
  }

  @override
  Future<Either<Failure, Event>> cancelAttendance(Event event) async {
    ///Remove event id from user's attending_event ids
    ///Remove user id from event data's attenders ids
    ///Remove img from ['attenders'] in eventsData and eventDetails
    var userId = _read<AuthBloc>().state.user!.id!;
    try {
      await _removeIds(event, userId);
      Map<String, dynamic> newEventMap = {};
      await FireSetup.waitForInit;
      await store.runTransaction((transaction) async {
        var docRef =
            store.collection(FireConstants.publicEventsCollName).doc(event.id);
        var doc = await transaction.get(docRef);
        newEventMap = doc.data()!..['id'] = doc.id;
        var attenders = (newEventMap['attenders_preview'] as List);
        bool hasUserInAttenders = attenders.contains(userId);

        if (hasUserInAttenders) {
          attenders.removeWhere((e) => e == userId);
          newEventMap['attenders_preview'] = attenders;
        }
        transaction.update(docRef, {
          if (hasUserInAttenders) 'attenders_preview': attenders,
          'attenders_count': FieldValue.increment(-1)
        });
      });

      newEventMap = FireStoreHelper.fromFirestoreConverter(newEventMap);
      return Right(EventModel.fromMap(newEventMap));
    } catch (e) {
      _addIds(event, userId, ignoreErrors: true);
      return const Left(Failure(/* cause: UnattendFailure() */));
    }
  }

  @override
  Future<Either<Failure?, dynamic>> getTickets(List<Ticket> tickets) async {
    var total = tickets.total;
    Either<Failure?, TransactionResult> res = total > 0
        ? await _read<IPurchaseManager>().userPay(total, refPrefix: 'tk')
        : Right(
            TransactionResult(_read<IPurchaseManager>().generateRefId('tk')),
          );

    return res.fold(
      (l) => Left(l),
      (r) async {
        await FireSetup.waitForInit;
        var eventsDataColl = store.collection(FireConstants.eventsDataCollName);
        var userId = _read<AuthBloc>().state.user!.id!;
        var batch = store.batch();
        List<String> ticketOrderIds = [];
        for (var ticket in tickets) {
          //  create ticket orders
          var orderDoc = eventsDataColl
              .doc(ticket.event.id)
              .collection(FireConstants.ticketOrdersCollName)
              .doc();
          batch.set(orderDoc, {
            'order_id': r.orderId,
            'ticket_id': ticket.id,
            'user_id': userId,
            'created_at': FieldValue.serverTimestamp(),
          });
          ticketOrderIds.add(orderDoc.id);
        }
        // add order ids to users ticket orders ids
        await FireSetup.waitForInit;
        batch.update(store.collection(FireConstants.usersCollName).doc(userId),
            {'ticket_orders': FieldValue.arrayUnion(ticketOrderIds)});
        try {
          // give user ticket
          List<Map<String, dynamic>> ticketsEventDocs = [];
          await Future.wait([
            batch.commit(),
            eventsDataColl
                .where(FieldPath.documentId,
                    whereIn: tickets.map((e) => e.event.id).toSet().toList())
                .get()
                .then((value) => ticketsEventDocs =
                    value.docs.map((e) => e.data()..['id'] = e.id).toList())
          ]);

          var ticketsStore = _read<MergedStore<OwnedTicket>>();
          for (var i = 0; i < ticketOrderIds.length; i++) {
            var eventData = ticketsEventDocs
                .firstWhere((e) => e['id'] == tickets[i].event.id);

            ticketsStore.put(OwnedTicketModel.withTicket(
              ticketOrderIds[i],
              tickets[i],
              orderId: r.orderId,
              qrData: _read<IEncryptor>().encrypt(
                json.encode({
                  'owned_ticket_id': ticketOrderIds[i],
                  'event_id': tickets[i].event.id,
                  'ticket_info': TicketModel.infoToMap(tickets[i])
                    ..remove('id'),
                }),
                EncryptKeyModel.fromMap(eventData),
              ),
            ));
          }
          await ticketsStore.backup();

          ///TODO call attend logic if no ticket has ticket's event id
          return Right(r);
        } catch (e, s) {
          print(e);
          print(s);
          return const Left(Failure(cause: GetTicketsFailure()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, dynamic>> cancelTicket(OwnedTicket ticket,
      {bool requestRefund = false}) async {
    return const Left(Failure(/* cause: CancelTicketFailure() */));

    ///remove id from tickets users data
    ///add ticket info to user data
    ///if no ticket with event id exists in user data, call unattend logic
  }
}
