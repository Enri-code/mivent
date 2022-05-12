import 'dart:async';

import 'package:image_picker/image_picker.dart';

class MediaService {
  static Future<XFile?> pickImage([bool fromCamera = false]) =>
      ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

  //static File? getProfilePicFromStorage() => File('$path/profile');
/*
  static shareText(Shareable item) => //TODO: share service function
      Share.share(item.toString(), subject: item.title); */
}
