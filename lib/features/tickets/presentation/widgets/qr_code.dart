import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDisplay extends StatelessWidget {
  const QRDisplay(this.data, {Key? key, this.color = Colors.black})
      : super(key: key);
  final String data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
      foregroundColor: color,
      padding: const EdgeInsets.all(8),
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.circle,
        color: Color.lerp(color, Colors.black, 0.5),
      ),

      ///TODO: Mivent logo
      //embeddedImage: ,
    );
  }
}
