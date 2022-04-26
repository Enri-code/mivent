import 'package:mivent/features/auth/domain/repos/auth_repo.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';

class SignIn {
  final IAuth _repo;
  const SignIn(this._repo);

  Future<UserData> call(String email, String password) =>
      _repo.signIn(email, password);
}

class GetSavedUser {
  final IAuth _repo;
  const GetSavedUser(this._repo);

  Future<UserData?> call() => _repo.getUpdatedUser();
}

class SignUp {
  final IAuth _repo;
  const SignUp(this._repo);

  Future<UserData> call(String email, String password,
          {Map<String, Object?> extraData = const {}}) =>
      _repo.signUp(email, password);
}

class AuthWithGoogle {
  final IAuth _repo;
  const AuthWithGoogle(this._repo);

  Future<UserData?> call() => _repo.signInWithGoogle();
}

class SignOut {
  final IAuth _repo;
  const SignOut(this._repo);

  Future<void> call() => _repo.signOut();
}

class SendPasswordResetEmail {
  final IAuth _repo;
  const SendPasswordResetEmail(this._repo);

  Future<void> call(String email) => _repo.sendPasswordResetEmail(email);
}

class ConfirmPasswordReset {
  final IAuth _repo;
  const ConfirmPasswordReset(this._repo);

  Future<void> call(String code, String newPassword) =>
      _repo.confirmPasswordReset(code, newPassword);
}
