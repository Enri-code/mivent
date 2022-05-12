part of 'bloc.dart';

enum AuthErrorCause { email, password, google }

class AuthState extends Equatable {
  final UserData? user;
  final Failure? failure;
  final bool justSignedIn;
  final OperationStatus status;

  const AuthState({
    this.user,
    required this.status,
    this.failure,
    this.justSignedIn = false,
  });

  factory AuthState.initial([UserData? user]) =>
      AuthState(status: OperationStatus.initial, user: user);

  AuthState copyWith({
    Failure? failure,
    UserData? user,
    OperationStatus? status,
    bool? justSignedIn,
  }) =>
      AuthState(
        user: user ?? this.user,
        status: status ?? this.status,
        failure: failure ?? this.failure,
        justSignedIn: justSignedIn ?? this.justSignedIn,
      );

  @override
  List<Object?> get props => [failure, user, status, justSignedIn];
}
