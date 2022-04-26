import 'package:flutter/cupertino.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';

class UserModel extends UserData {
  ///[id], [email], [displayName], [type], [image]
  UserModel.fromMap(Map<String, Object?> map)
      : super(
          id: map["id"] as String,
          email: map["email"] as String,
          displayName: map["name"] as String,
          type: map["type"] as UserType,
        ) {
    if (map["image_url"] != null) {
      super.image = NetworkImage(map["image_url"].toString());
    }
  }
}
