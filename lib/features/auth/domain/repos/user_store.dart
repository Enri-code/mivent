import 'dart:async';

import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';

abstract class IUserStore {
  Future init();

  UserType get type;
  UserData? get user;
  bool get isSignedIn;

  saveType(UserType type);
  saveUser(UserData user);
  delete();
}
