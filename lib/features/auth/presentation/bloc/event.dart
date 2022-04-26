part of 'bloc.dart';

abstract class AuthEvent {}

class _EmitEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

/// Ensure you catch the error for if email exists or not for sign up and sign in
/// respectively
class GoogleAuthEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}

class ConfirmPasswordResetEvent extends AuthEvent {
  final String code;
  final String newPassword;
  ConfirmPasswordResetEvent({required this.newPassword, required this.code});
}
