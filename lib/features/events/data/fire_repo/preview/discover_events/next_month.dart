import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/events/data/fire_repo/sections.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';

class FireNextMonthEventsRepo extends IEventSectionRepo {
  FireNextMonthEventsRepo(this.repo);
  @override
  bool showMore = true;

  @override
  final FireEventsProvider repo;

  @override
  String title = 'Next month';

  @override
  final EventSectionType? type = null;

  @override
  DocumentSnapshot<Object?>? lastEventRef;

  @override
  Future<List<Event>> getEvents([limit = 5]) async {
    var timestamp = await FireSetup.serverTimeStamp;
    var date = timestamp.toDate();
    Query<Map<String, dynamic>> query = (await FireStoreHelper.eventsCollection)
        .where(
          'start_time',
          isGreaterThan:
              Timestamp.fromDate(DateTime(date.year, date.month + 1)),
        )
        .where(
          'start_time',
          isLessThan: Timestamp.fromDate(DateTime(date.year, date.month + 2)),
        )
        .orderBy('start_time');

    var docs = await repo.getDocs(limit, lastEventRef, query);
    if (docs.isEmpty) return [];
    lastEventRef = docs.last;
    var data = await repo.getData(docs.map((e) => e.data()).toList());
    return data;
  }
}
