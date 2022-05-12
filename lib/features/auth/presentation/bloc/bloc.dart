import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mivent/core/error/failure.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/auth/domain/repos/auth_repo.dart';
import 'package:mivent/features/auth/domain/use_cases.dart';

part 'event.dart';
part 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo, this.read)
      : super(AuthState.initial(_repo.userStore.user)) {
    on<_SetUserEvent>(_init);
    on<GoogleAuthEvent>(_googleAuth);
    on<SignUpEvent>(_signUp);
    on<SignInEvent>(_signIn);
    on<SignOutEvent>(_signOut);
    _initialize();
  }
  final IAuth _repo;
  final Reader read;

  UserType get userType => _repo.type;
  set userType(UserType type) => _repo.type = type;

  _initialize() async {
    var user = await GetRemoteUser(_repo).call();
    if (user != null) add(_SetUserEvent(user));
  }

  void _init(_SetUserEvent event, Emitter<AuthState> emit) =>
      emit(state.copyWith(user: event.user));

  void _googleAuth(GoogleAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: OperationStatus.majorLoading));
    var response = await AuthWithGoogle(_repo).call(event.newUser);
    response.fold(
      (l) {
        if (l != null) {
          emit(state.copyWith(status: OperationStatus.minorFail, failure: l));
        }
      },
      (r) {
        _repo.userStore.saveUser(r);
        emit(state.copyWith(
            user: r, status: OperationStatus.success, justSignedIn: true));
      },
    );
  }

  void _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    var response = await SignIn(_repo).call(event.email, event.password);
    response.fold(
        (l) =>
            emit(state.copyWith(status: OperationStatus.minorFail, failure: l)),
        (r) {
      _repo.userStore.saveUser(r);
      emit(state.copyWith(
          user: r, status: OperationStatus.success, justSignedIn: true));
    });
  }

  void _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    var response =
        await SignUp(_repo).call(event.email, event.password, event.extraData);
    response.fold(
        (l) =>
            emit(state.copyWith(status: OperationStatus.minorFail, failure: l)),
        (r) {
      _repo.userStore.saveUser(r);
      emit(state.copyWith(
          user: r, status: OperationStatus.success, justSignedIn: true));
    });
  }

  void _signOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: OperationStatus.minorLoading));
    var error = await SignOut(_repo, read).call();
    if (error == null) {
      emit(state.copyWith(user: null, status: OperationStatus.success));
    } else {
      emit(state.copyWith(status: OperationStatus.minorFail, failure: error));
    }
  }
}
