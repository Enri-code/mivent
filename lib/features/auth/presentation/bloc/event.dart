part of 'bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class _SetUserEvent extends AuthEvent {
  const _SetUserEvent(this.user);
  final UserData user;
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final Map<String, Object?> extraData;

  const SignUpEvent({
    required this.email,
    required this.password,
    this.extraData = const {},
  });
}

class GoogleAuthEvent extends AuthEvent {
  const GoogleAuthEvent(this.newUser);
  final bool newUser;
}

class SignOutEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent(this.email);
  final String email;
}

class ConfirmPasswordResetEvent extends AuthEvent {
  const ConfirmPasswordResetEvent({
    required this.newPassword,
    required this.code,
  });

  final String code;
  final String newPassword;
}
