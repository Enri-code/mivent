// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/events/domain/repos/sections.dart';

abstract class SampleHelper {
  /* {end_time: Timestamp(seconds=1654642800, nanoseconds=0), end_price: 50000, location: Love garden, has_ticket: true, attenders_preview: [4OjHXTHV8MZUcf91CxavNa1g8nn1], name: House party, start_time: Timestamp(seconds=1654124400, nanoseconds=0), expiration_time: Timestamp(seconds=1654556400, nanoseconds=0), images_count: 1, attenders_count: 1, start_price: 0} */
  static collMover(String oldPath, String newPath) async {
    await FireSetup.waitForInit;
    var snapShot = await FirebaseFirestore.instance.collection(oldPath).get();
    var coll = FirebaseFirestore.instance.collection(newPath);
    for (var e in snapShot.docs) {
      await coll.doc(e.id).set(e.data());
    }
    print('done moving');
  }

  static fieldsUpdate(String collPath, Map<String, dynamic> newData) async {
    await FireSetup.waitForInit;
    var snapShot = await FirebaseFirestore.instance.collection(collPath).get();
    var batch = FirebaseFirestore.instance.batch();
    for (var e in snapShot.docs) {
      batch.set(e.reference, newData, SetOptions(merge: true));
    }
    await batch.commit();
    print('done updating');
  }

  static callRemoteEvents(IRemoteEventsProvider provider) async {
    await FireSetup.waitForInit;
    for (var e in provider.eventSectionRepos) {
      e.getEvents();
    }
  }

  static fieldRenamer(
    DocumentReference<Map<String, dynamic>> docRef,
    String oldName,
    String newName,
  ) async {
    var doc = (await docRef.get()).data();
    doc![newName] = doc[oldName];
    doc[oldName] = FieldValue.delete();
    await docRef.update(doc);
  }

  static docDuplicator(
      DocumentReference<Map<String, dynamic>> Function(FirebaseFirestore)
          docRef,
      {String? newDocId,
      int iterations = 1}) async {
    await FireSetup.waitForInit;
    var doc = docRef(FirebaseFirestore.instance);
    var data = await doc.get();
    print('gotton');
    for (var i = 0; i < iterations; i++) {
      await doc.parent.doc(newDocId).set(data.data() ?? {});
    }
    print(data.data());
    print('done copying doc-${doc.id} into $newDocId');
  }
}
