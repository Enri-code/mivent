import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/events/data/fire_repo/sections.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';
import 'package:mivent/features/events/presentation/widgets/section.dart';
import 'package:mivent/features/store/data/stores/mixins.dart';

class FireAttendingEventsRepo extends IEventSectionRepo {
  FireAttendingEventsRepo(this.repo);

  @override
  final FireEventsProvider repo;
  @override
  bool showMore = false;
  @override
  get title => null;
  @override
  final type = TileSectionType();
  @override
  DocumentSnapshot<Object?>? lastEventRef;

  @override
  Future<List<Event>> getEvents([limit = 8]) async {
    String? id = repo.read<AuthBloc>().state.user?.id;
    var items = repo.read<AttendingEventsStore>().items;
    if (id == null || items.isEmpty) return [];
    var query = (await FireStoreHelper.availableEvents).where(
        FieldPath.documentId,
        whereIn: items);
    var docs = await repo.getDocs(limit, lastEventRef, query);
    print(
      'requested ids: ${repo.read<AttendingEventsStore>().items}',
    );
    print('returned docs: ${docs.map((e) => e.id)}');
    if (docs.isEmpty) return [];
    lastEventRef = docs.last;
    return repo.getData(docs.map((e) => e.data()).toList(), true);
  }
}
