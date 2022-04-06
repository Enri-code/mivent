import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mivent/models/user.dart';
import 'package:mivent/domain/interfaces/auth_repo.dart';

class FireAuth extends IAuth {
  final fireAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  @override
  Future<UserData> signIn({
    required String email,
    required String password,
  }) async {
    var credential = await fireAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    var doc =
        await fireStore.collection('users').doc(credential.user!.uid).get();
    return UserData(
      firstName: doc.get('first_name'),
      lastName: doc.get('last_name'),
      fireUser: credential.user,
    );
  }

  @override
  Future<UserData> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    var credential = await fireAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await fireStore.collection('users').doc(credential.user!.uid).set({
      'first_name': firstName,
      'last_name': lastName,
    });
    return UserData(
      firstName: firstName,
      lastName: lastName,
      fireUser: credential.user,
    );
  }

  @override
  Future<void> signOut() => fireAuth.signOut();

  @override
  Future changePassword(String email) {
    throw UnimplementedError();
  }
}
