import 'package:mivent/features/auth/domain/entities/user_type.dart';

class UserData {
  UserData({
    required this.id,
    required this.displayName,
    required this.email,
    this.imageUrl,
    this.type = const AttenderUser(),
  });

  String? id;
  String displayName, email;
  String? imageUrl;
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
