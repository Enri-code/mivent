import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mivent/core/utils/extensions/map_opener.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.position, {Key? key}) : super(key: key);

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
          liteModeEnabled: true,
          initialCameraPosition: CameraPosition(
            tilt: 30,
            zoom: 18,
            target: widget.position,
          ),
          markers: {
            Marker(markerId: const MarkerId(''), position: widget.position),
          },
          onMapCreated: (_) => setState(() => loading = false),
          onTap: (_) => setState(() => loading = true),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xE1FFFFFF),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
            ),
            child: const Text('Tap to open in maps', style: TextStyles.hint1),
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
                await widget.position.openInMaps();
                setState(() => loading = false);
              }
            },
          ),
        ),
      ],
    );
  }
}
