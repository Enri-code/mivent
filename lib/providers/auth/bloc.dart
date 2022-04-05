import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mivent/models/user.dart';
import 'package:mivent/domain/services/fb_auth.dart';

part 'event.dart';
part 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_signUpLogic);
    on<SignInEvent>(_signInLogic);
    on<SignOutEvent>(_signOutLogic);
    on<ForgotPasswordEvent>(_changePasswordLogic);
  }

  final _api = FireAuth();

  void _signInLogic(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var user = await _api.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
    }
  }

  void _signUpLogic(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var user = await _api.signUp(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
    }
  }

  void _signOutLogic(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _api.signOut();
    } on FirebaseAuthException catch (e) {}
  }

  void _changePasswordLogic(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _api.changePassword(event.email);
      emit(PasswordChangeSuccess());
    } on FirebaseAuthException catch (e) {
      //emit(AuthError(errMessage: e.msg));
    }
  }
}
