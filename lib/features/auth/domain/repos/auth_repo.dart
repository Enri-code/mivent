import 'dart:async';

import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';

abstract class IAuth {
  UserType get type;

  set type(UserType val);

  Future<UserData?> getUpdatedUser();

  Future<UserData> signIn(String email, String password);

  Future<UserData?> signInWithGoogle();

  Future<UserData> signUp(String email, String password,
      {Map<String, Object?> extraData = const {}});

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> confirmPasswordReset(String code, String newPassword);
}
