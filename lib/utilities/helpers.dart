import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Constants {
  final emailFilter = RegExp(
      r"^[-!#$%&'*+/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+/0-9=?A-Z^_a-z{|}~])*@[a-zA-Z](-?[a-zA-Z0-9])*(\.[a-zA-Z](-?[a-zA-Z0-9])*)+$");
}

class Functions {
  static Future<MemoryImage?> pickImage(ImageSource source) async {
    var img = await ImagePicker().pickImage(source: source);
    if (img == null) return null;
    var bytes = await img.readAsBytes();
    return MemoryImage(bytes);
  }
}
