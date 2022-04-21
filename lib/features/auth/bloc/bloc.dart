import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/auth/domain/repo.dart';

part 'event.dart';
part 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(AuthState.initial()) {
    on<_InitEvent>(_init);
    on<GoogleAuthEvent>(_googleAuth);
    on<SignUpEvent>(_signUp);
    on<SignInEvent>(_signIn);
    on<SignOutEvent>(_signOut);
  }
  final Auth _repo;

  UserType get userType => _repo.type;
  set userType(UserType type) => _repo.type = type;

  UserData? _user;
  UserData? get user => _user;

  void _init(_InitEvent event, Emitter<AuthState> emit) async {
    try {
      _user = await _repo.tryGetSavedUser();
      emit(state.copyWith(user: _user, status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failed, error: null));
    }
  }

  void _googleAuth(GoogleAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.fullScreenLoading));
    try {
      _user = await _repo.signInWithGoogle();
      emit(state.copyWith(user: _user, status: AuthStatus.success));
    } on Exception catch (_) {
      emit(state.copyWith(
        status: AuthStatus.failed,
        error: const AuthError(cause: AuthErrorCause.google),
      ));
    }
  }

  void _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.miniLoading));
    try {
      _user = await _repo.signIn(event.email, event.password);
      emit(state.copyWith(user: _user, status: AuthStatus.success));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(state.copyWith(
            status: AuthStatus.failed,
            error: const AuthError(
              cause: AuthErrorCause.email,
              message:
                  'There is no account with this email. Create one instead',
            ),
          ));
          break;
        case 'wrong-password':
          emit(state.copyWith(
            status: AuthStatus.failed,
            error: const AuthError(
                cause: AuthErrorCause.password,
                message: 'Your password is wrong. Please try again'),
          ));
          break;
        default:
          emit(state.copyWith(status: AuthStatus.failed, error: null));
          rethrow;
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: AuthStatus.failed, error: null));
    }
  }

  void _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.miniLoading));
    try {
      _user = await _repo
          .signUp(event.email, event.password, extraData: {'name': event.name});
      emit(state.copyWith(user: _user, status: AuthStatus.success));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          emit(state.copyWith(
            status: AuthStatus.failed,
            error: const AuthError(
                cause: AuthErrorCause.password,
                message: 'Please use a stronger password'),
          ));
          break;
        case 'email-already-in-use':
          emit(state.copyWith(
            status: AuthStatus.failed,
            error: const AuthError(
                cause: AuthErrorCause.email,
                message: 'This email is already in use. Please log in instead'),
          ));
          break;
        default:
          emit(state.copyWith(status: AuthStatus.failed, error: null));
          break;
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: AuthStatus.failed, error: null));
    }
  }

  void _signOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.miniLoading));
    try {
      await _repo.signOut();
      _user = null;
      emit(state.copyWith(user: null, status: AuthStatus.success));
    } on Exception catch (_) {
      emit(state.copyWith(status: AuthStatus.failed, error: null));
    }
  }
}
