import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';

@HiveType(typeId: 4)
class UserData {
  UserData({
    required this.id,
    required this.displayName,
    required this.email,
    this.image,
    this.type = const AttenderUser(),
  });

  @HiveField(0)
  String? id;
  @HiveField(1)
  String displayName;
  @HiveField(2)
  String email;
  ImageProvider<Object>? image;
  UserType type;

  static UserData get empty => UserData(id: '', displayName: '', email: '');

  @override
  bool operator ==(dynamic other) {
    if (other == UserData) {
      return (id ?? -1) == (other.id ?? 1);
    }
    return this == other;
  }

  @override
  int get hashCode => id.hashCode;
}
