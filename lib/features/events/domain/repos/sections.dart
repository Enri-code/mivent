import 'dart:math';

import 'package:mivent/features/events/domain/repos/preview/get_event.dart';

abstract class IRemoteEventsProvider {
  IEventSectionRepo? lastRepo;
  List<IEventSectionRepo> get eventSectionRepos;

  IEventSectionRepo get randomRepo {
    var random = Random().nextInt(eventSectionRepos.length - 1);
    var available = eventSectionRepos.where((e) => e != lastRepo).toList();
    return lastRepo = available[random];
  }
}
