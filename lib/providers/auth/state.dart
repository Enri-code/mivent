part of 'bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String errMessage;
  const AuthError({required this.errMessage});
  @override
  List<Object> get props => [errMessage];
}

class AuthSuccess extends AuthState {
  final UserData user;
  const AuthSuccess({required this.user});
  @override
  List<Object> get props => [user];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class PasswordChangeSuccess extends AuthState {
  @override
  List<Object> get props => [];
}
