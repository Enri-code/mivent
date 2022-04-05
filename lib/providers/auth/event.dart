part of 'bloc.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  SignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class SignOutEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent({required this.email});
}

class ErrorEvent extends AuthEvent {}
