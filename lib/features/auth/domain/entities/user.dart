import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';

@HiveType(typeId: 4)
class UserData {
  UserData({
    required this.id,
    required this.displayName,
    required this.email,
    this.imageUrl,
    this.phoneNumber,
    this.type = const AttenderUser(),
  });

  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String displayName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final String? phoneNumber;

  UserType type;

  static UserData get empty => UserData(id: '', displayName: '', email: '');

  static copyWith({String? displayName, String? email}) {}

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
