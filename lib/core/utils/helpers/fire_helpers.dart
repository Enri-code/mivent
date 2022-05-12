import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:mivent/core/services/server_functions.dart';

class FireConstants {
  static String publicEventsCollName = 'public_events',
      eventsDataCollName = 'events_data',
      eventDetailsCollName = 'events_details',
      ticketOrdersCollName = 'ticket_orders',
      ticketsCollName = 'tickets',
      usersCollName = 'users';

  static String eventsPath = 'events/',
      ticketsPath = 'tickets/',
      usersPath = 'users/';
}

class FireSetup {
  static final _initializer = Completer();

  static Future get waitForInit => _initializer.future;
  static int _trials = 0;

  static Future mainInit() async {
    try {
      await Firebase.initializeApp();
      _initializer.complete();
    } catch (e) {
      if (_trials++ < 4) {
        mainInit();
      } else {
        _initializer.completeError(e);
      }
    }
  }

  static Future<Timestamp> get serverTimeStamp async =>
      Timestamp.fromMillisecondsSinceEpoch(
          (await ServerFunctions.epochTimeOfMinutes) - 60);
}

class FireStoreHelper {
  static Future<CollectionReference<Map<String, dynamic>>>
      get eventsCollection async {
    await FireSetup.waitForInit;
    return FirebaseFirestore.instance
        .collection(FireConstants.publicEventsCollName)
        .withConverter<Map<String, Object?>>(
          fromFirestore: (doc, _) =>
              fromFirestoreConverter(doc.data()!..['id'] = doc.id),
          toFirestore: (data, _) {
            data.remove('id');
            data.remove('image_future');
            data.remove('attenders_futures');
            data['start_time'] =
                Timestamp.fromMillisecondsSinceEpoch(data['start_time'] as int);
            if (data['end_time'] != null) {
              data['end_time'] =
                  Timestamp.fromMillisecondsSinceEpoch(data['end_time'] as int);
            }
            return data;
          },
        );
  }

  static Future<Query<Map<String, dynamic>>> get availableEvents async =>
      (await eventsCollection).where('expiration_time',
          isGreaterThanOrEqualTo: await FireSetup.serverTimeStamp);
  static Map<String, dynamic> fromFirestoreConverter(
      Map<String, dynamic> data) {
    data['start_time'] =
        (data['start_time'] as Timestamp).millisecondsSinceEpoch;
    data['end_time'] = (data['end_time'] as Timestamp?)?.millisecondsSinceEpoch;
    data = setAttenderImageGetters(data);
    data = setPreviewImageGetter(data, FireConstants.eventsPath);
    return data;
  }

  static Map<String, dynamic> setAttenderImageGetters(
      Map<String, dynamic> data) {
    data['attenders_futures'] = [
      for (var i in (data['attenders_preview'] as List).take(5))
        FirebaseStorage.instance
            .ref('${FireConstants.usersPath}$i/thumb.jpg')
            .getData()
    ];
    return data;
  }

  ///Returns ['image_future'] future that downloads image as [Uint8List]
  static Map<String, dynamic> setPreviewImageGetter(
    Map<String, dynamic> data,
    String folderName,
  ) {
    var hasImage =
        (data['images_count'] ?? 0) > 0 || (data['has_image'] ?? false);
    if (hasImage) {
      data['image_future'] = FirebaseStorage.instance
          .ref('$folderName${data['id']}/preview.jpg')
          .getData();
    } else {
      data['image_future'] = null;
    }
    return data;
  }
}
