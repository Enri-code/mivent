import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/free_events.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/next_month.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/popular_events.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/random.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/this_month_events.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/this_weekend.dart';
import 'package:mivent/features/events/domain/repos/preview/get_event.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/sections.dart';
import 'package:mivent/features/events/data/models/event.dart';

class FireEventsProvider extends IRemoteEventsProvider {
  FireEventsProvider(this.read) {
    eventSectionRepos = [
      FireThisWeekendEventsRepo(this),
      FireThisMonthEventsRepo(this),
      FireNextMonthEventsRepo(this),
      FireRandomEventsRepo(this),
      FireFreeEventsRepo(this),
      FirePopularEventsRepo(this),
    ];
  }
  final Reader read;
  @override
  late final List<IEventSectionRepo> eventSectionRepos;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocs(
    int limit,
    DocumentSnapshot<Object?>? lastEventRef,
    Query<Map<String, dynamic>> query,
  ) async {
    if (lastEventRef != null) query = query.startAfterDocument(lastEventRef);
    return (await query.limit(limit).get()).docs;
  }

  Future<List<Event>> getData(List<Map<String, dynamic>> docsData,
      [bool shuffle = false]) async {
    var data = [for (var e in docsData) EventModel.fromMap(e)];
    if (shuffle) data.shuffle();
    return data;
  }
}
