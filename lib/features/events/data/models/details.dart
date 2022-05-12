import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mivent/features/events/domain/entities/details.dart';

class EventDetailModel extends EventDetail {
  EventDetailModel._(
    String id, {
    String description = '',
    LatLng? mapPoint,
  }) : super(
          id,
          mapPoint: mapPoint,
          description: description,
        );

  ///map'id',
  ///
  ///mapPosition: 'map_point',
  ///
  ///description: 'description',
  ///
  ///otherImageUrls: 'image_urls'
  ///
  ///isBeingAttended: map['is_being_attended'],
  factory EventDetailModel.fromMap(Map<String, dynamic> map) {
    var geoPoint = map['map_point'] as GeoPoint?;
    LatLng? mapPoint;
    if (geoPoint != null) {
      mapPoint = LatLng(geoPoint.latitude, geoPoint.longitude);
    }
    return EventDetailModel._(
      map['id'],
      mapPoint: mapPoint,
      description: map['description'],
    );
  }
}
