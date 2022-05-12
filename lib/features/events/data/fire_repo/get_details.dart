import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/events/data/models/details.dart';
import 'package:mivent/features/events/domain/entities/details.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/get_details.dart';
import 'package:mivent/features/tickets/data/models/ticket.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';

class FireEventDetails extends IEventDetails {
  FireEventDetails();

  @override
  Future<Either<void, EventDetail?>> getDetails(String id) async {
    try {
      var query = await FirebaseFirestore.instance
          .collection(FireConstants.eventDetailsCollName)
          .withConverter<Map<String, Object?>>(
            fromFirestore: (doc, _) {
              var data = doc.data()!;
              data['id'] = doc.id;
              return data;
            },
            toFirestore: (data, _) => data,
          )
          .where(FieldPath.documentId, isEqualTo: id)
          .limit(1)
          .get();
      if (query.docs.isEmpty) return const Right(null);
      return Right(EventDetailModel.fromMap(query.docs.first.data()));
    } catch (e, s) {
      print(e);
      print(s);
      return const Left(null);
    }
  }

  @override
  Future<Either<void, List<Ticket>>> getRemoteEventTickets(Event event) async {
    try {
      var query = await FirebaseFirestore.instance
          .collection(
            '${FireConstants.eventsDataCollName}/${event.id}/${FireConstants.ticketsCollName}',
          )
          .withConverter<Map<String, Object?>>(
            fromFirestore: (doc, _) {
              var data = doc.data()!;
              data['id'] = doc.id;
              data = FireStoreHelper.setPreviewImageGetter(
                  data, FireConstants.ticketsPath);
              return data;
            },
            toFirestore: (data, _) => data,
          )
          .where('event_id', isEqualTo: event.id)
          .orderBy('price')
          .get();
      return Right([
        for (var e in query.docs)
          TicketModel.fromMap(e.data()..['event'] = event)
      ]);
    } catch (e, s) {
      print(e);
      print(s);
      return const Left(null);
    }
  }
}
