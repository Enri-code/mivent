import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/events/data/fire_repo/sections.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';

class FirePopularEventsRepo extends IEventSectionRepo {
  FirePopularEventsRepo(this.repo);

  @override
  final FireEventsProvider repo;

  @override
  bool showMore = false;

  @override
  String title = 'Popular';

  @override
  final type = CardSectionType();

  @override
  DocumentSnapshot<Object?>? lastEventRef;

  @override
  Future<List<Event>> getEvents([limit = 4]) async {
    var query = (await FireStoreHelper.availableEvents)
        .orderBy('expiration_time')
        .orderBy('attenders_count', descending: true);
    var docs = await repo.getDocs(limit, lastEventRef, query);
    if (docs.isEmpty) return [];
    lastEventRef = docs.last;
    var maps = docs.map((e) => e.data()).toList();
    var data = await repo.getData(maps, true);
    return data;
  }
}
