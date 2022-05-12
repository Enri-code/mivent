import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';

class UserModel extends UserData {
///
  ///id: "id" as String,
  ///
  ///email: "email" as String,
  ///
  ///displayName: "display_name" as String,
  ///
  ///type: 'type' as UserType,
  ///
  ///imageUrl: 'image_url' as String?,
  ///
  ///phoneNumber: "phone_number" as String?,
  UserModel.fromMap(Map<String, Object?> map)
      : super(
          id: map["id"] as String,
          email: map["email"] as String,
          displayName: map["display_name"] as String,
          phoneNumber: map["phone_number"] as String?,
          imageUrl: map["image_url"] as String?,
          type: map["type"] as UserType,
        );
/*
  toMap() => {
        'id': id,
        'email': email,
        'display_name': displayName,
        'type': type.toString(),
        'image_url': imageUrl,
      }; */
}
