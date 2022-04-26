import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'package:mivent/features/share/domain/entities/shareable.dart';

class MediaService {
  static Future<MemoryImage?> pickImage([bool fromCamera = false]) async {
    var img = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (img == null) return null;
    var bytes = await img.readAsBytes();
    return MemoryImage(bytes);
  }

  static shareText(Shareable item) =>
      Share.share(item.toString(), subject: item.title);
}
