import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/events/data/fire_repo/sections.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';

class FireFreeEventsRepo extends IEventSectionRepo {
  FireFreeEventsRepo(this.repo);

  @override
  final FireEventsProvider repo;

  @override
  bool showMore = true;

  @override
  String title = 'FREE';

  @override
  final type = TileSectionType();

  @override
  DocumentSnapshot<Object?>? lastEventRef;

  @override
  Future<List<Event>> getEvents([limit = 8]) async {
    var query = (await FireStoreHelper.availableEvents)
        .where('start_price', isEqualTo: 0)
        .orderBy('expiration_time')
        .orderBy('attenders_count', descending: true);

    var docs = await repo.getDocs(limit, lastEventRef, query);
    if (docs.isEmpty) return [];
    lastEventRef = docs.last;
    var data = await repo.getData(docs.map((e) => e.data()).toList(), true);
    return data;
  }
}
