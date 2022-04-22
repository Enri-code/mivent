import 'package:mivent/features/auth/domain/entities/user_type.dart';

class UserTypeModel extends UserType {
  static fromString(String value) {
    switch (value) {
      case 'host':
        return const HostUser();
      default:
        return const AttenderUser();
    }
  }
}
