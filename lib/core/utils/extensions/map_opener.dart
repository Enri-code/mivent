import 'package:map_launcher/map_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

extension MyLatLngExt on LatLng {
  Future<bool> openInMaps([String title = '']) async {
    try {
      var maps = await MapLauncher.installedMaps;
      if (maps.isNotEmpty) {
        await maps.first
            .showMarker(coords: Coords(latitude, longitude), title: title);
      } else {
        await launchUrl(
          Uri.parse('https://www.google.com/maps/search/?api=1&'
              'query=$latitude,$longitude'),
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: 'Event Location',
        );
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
