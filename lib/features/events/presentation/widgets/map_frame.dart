import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mivent/core/utils/extensions/map_opener.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.position, {Key? key, this.name = ''}) : super(key: key);
  final String name;
  final LatLng position;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  var loading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            tilt: 30,
            zoom: 18,
            target: widget.position
          ),
          markers: {
            Marker(
                markerId: const MarkerId('Event'), position: widget.position),
          },
          onMapCreated: (_) => setState(() => loading = false),
          onTap: (_) => setState(() => loading = true),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
            ),
            child:
                const Text('Tap to open in your map', style: TextStyles.hint1),
          ),
        ),
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: loading ? 1 : 0,
            duration: kThemeAnimationDuration,
            child: Container(
              color: Colors.white30,
              child: const Center(child: CircularProgressIndicator()),
            ),
            onEnd: () async {
              if (loading) {
                await widget.position.openInMaps(widget.name);
                setState(() => loading = false);
              }
            },
          ),
        ),
      ],
    );
  }
}
