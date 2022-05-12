import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/auth/domain/repos/user_store.dart';

abstract class IAuth {
  IAuth(this.userStore);
  final IUserStore userStore;

  UserType get type => userStore.type;
  set type(UserType val) => userStore.saveType(val);

  Future<UserData?> getRemoteUser();

  Future<Either<Failure, UserData>> signIn(
      String email, String password);

  Future<Either<Failure?, UserData>> authWithGoogle(bool newUser);

  Future<Either<Failure, UserData>> signUp(String email, String password,
      Map<String, Object?> extraData);

  Future<Failure?> signOut();

  Future<Failure?> sendPasswordResetEmail(String email);

  Future<Failure?> confirmPasswordReset(String code, String newPassword);
}
