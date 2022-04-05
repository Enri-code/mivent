import 'package:mivent/models/user.dart';

abstract class AuthBase {
  Future<UserData> signIn({required String email, required String password});

  Future<UserData> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future changePassword(String email);
}
