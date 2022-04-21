part of 'bloc.dart';

//enum AuthProvider { google, password }

enum AuthErrorCause { email, password, google }
enum AuthStatus { initial, success, failed, miniLoading, fullScreenLoading }

class AuthError {
  static const defaultMessage = 'An error occured. Please try again later';

  const AuthError({String? message, this.cause})
      : message = message ?? defaultMessage;

  final AuthErrorCause? cause;
  final String message;
}

class AuthState extends Equatable {
  final UserData? user;
  final AuthError? error;
  final AuthStatus status;

  const AuthState({this.user, required this.status, this.error});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  AuthState copyWith({AuthError? error, UserData? user, AuthStatus? status}) {
    return AuthState(
        error: error ?? this.error,
        user: user ?? this.user,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [error, user, status];
}
