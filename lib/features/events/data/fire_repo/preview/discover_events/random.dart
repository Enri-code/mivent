import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/events/data/fire_repo/sections.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';

class FireRandomEventsRepo extends IEventSectionRepo {
  FireRandomEventsRepo(this.repo);
  @override
  bool showMore = true;

  @override
  final FireEventsProvider repo;

  @override
  String title = 'More';

  @override
  final type = TileSectionType();

  @override
  DocumentSnapshot<Object?>? lastEventRef;

  @override
  Future<List<Event>> getEvents([limit = 8]) async {
    var query =
        (await FireStoreHelper.availableEvents).orderBy('expiration_time');
    var docs = await repo.getDocs(limit, lastEventRef, query);
    if (docs.isEmpty) return [];
    lastEventRef = docs.last;
    return await repo.getData(docs.map((e) => e.data()).toList(), true);
  }
}
