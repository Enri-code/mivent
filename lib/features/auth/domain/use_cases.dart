import 'package:dartz/dartz.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/auth/domain/repos/auth_repo.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';

class GetRemoteUser {
  final IAuth _repo;
  const GetRemoteUser(this._repo);

  Future<UserData?> call() => _repo.getRemoteUser();
}

class SignIn {
  final IAuth _repo;
  const SignIn(this._repo);

  Future<Either<Failure, UserData>> call(String email, String password) =>
      _repo.signIn(email, password);
}

class SignUp {
  final IAuth _repo;
  const SignUp(this._repo);

  Future<Either<Failure, UserData>> call(
          String email, String password, Map<String, Object?> extraData) =>
      _repo.signUp(email, password, extraData);
}

class AuthWithGoogle {
  final IAuth _repo;
  const AuthWithGoogle(this._repo);

  Future<Either<Failure?, UserData>> call(bool newUser) =>
      _repo.authWithGoogle(newUser);
}

class SignOut {
  final IAuth _repo;
  final Reader read;
  const SignOut(this._repo, this.read);

  Future<Failure?> call() async {
    try {
      await Future.wait(<Future>[
        read<EventsBloc>().backup(),
        _repo.userStore.delete(),
      ]);
    } catch (e) {
      return const Failure();
    }
    return _repo.signOut();
  }
}

class SendPasswordResetEmail {
  final IAuth _repo;
  const SendPasswordResetEmail(this._repo);

  Future<Failure?> call(String email) => _repo.sendPasswordResetEmail(email);
}

class ConfirmPasswordReset {
  final IAuth _repo;
  const ConfirmPasswordReset(this._repo);

  Future<Failure?> call(String code, String newPassword) =>
      _repo.confirmPasswordReset(code, newPassword);
}
