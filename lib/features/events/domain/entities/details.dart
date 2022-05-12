import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetail {
  EventDetail(
    this.id, {
    //this.otherImageUrls = const [],
    this.description = '',
    this.mapPoint,
  });

  final String id, description;
  final LatLng? mapPoint;
  //final List<String> otherImageUrls;
/*
  EventDetail copyWith({
    String? description,
    LatLng? mapPoint,
    bool? isBeingAttended,
    List<String>? otherImageUrls,
  }) =>
      EventDetail(
        id,
        mapPoint: mapPoint ?? this.mapPoint,
        description: description ?? this.description,
        otherImageUrls: otherImageUrls ?? this.otherImageUrls,
        isBeingAttended: isBeingAttended ?? this.isBeingAttended,
      );
 */
}
