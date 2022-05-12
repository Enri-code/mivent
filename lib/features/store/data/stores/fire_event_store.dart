import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/events/data/models/event.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/store/data/fire_storage.dart';

class FireEventStorage extends FireStorage<Event, Map<String, dynamic>> {
  FireEventStorage(String key, {bool autoUpdate = false})
      : super(
          key,
          autoUpdate: autoUpdate,
          querySource: () => FireStoreHelper.availableEvents,
          fromConverter: (doc) async => EventModel.fromMap(doc),
        );
}
