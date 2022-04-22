import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mivent/core/exceptions/auth.dart';
import 'package:mivent/features/auth/data/models/user_model.dart';
import 'package:mivent/features/auth/data/models/user_type_model.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/repo.dart';

class FireAuth extends IAuth {
  FireAuth();

  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<UserData> _getUserData(User user) async {
    var data = await fireStore.collection('users').doc(user.uid).get();
    return UserModel.fromMap({
      'id': user.uid,
      'email': user.email!,
      'name': user.displayName!,
      'image_url': user.photoURL,
      'type': UserTypeModel.fromString(data['type']),
    });
  }

  @override
  Future<UserData?> tryGetSavedUser() async {
    var user = fireAuth.currentUser;
    if (user != null) return await _getUserData(fireAuth.currentUser!);
    return null;
  }

  @override
  Future<UserData> signIn(String email, String password) async {
    var credential = await fireAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return _getUserData(credential.user!);
  }

  @override
  Future<UserData?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ));

      final user = credential.user!;
      if (credential.additionalUserInfo!.isNewUser) {
        await fireStore
            .collection('users')
            .doc(user.uid)
            .set({'type': type.toString()});
      }

      return _getUserData(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        var methods = await fireAuth.fetchSignInMethodsForEmail(e.email!);
        throw AuthException('Please sign in with: ' +
            methods
                .map((e) => e[0].toUpperCase() + e.substring(1))
                .join(' or '));
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<UserData> signUp(String email, String password,
      {Map<String, Object?> extraData = const {}}) async {
    var user = (await fireAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user!;

    await fireStore
        .collection('users')
        .doc(user.uid)
        .set({'type': type.toString()});

    user.updateDisplayName(extraData['name'] as String);

    return UserModel.fromMap(
        {'id': user.uid, 'type': type, 'email': email, ...extraData});
  }

  @override
  Future<void> signOut() => fireAuth.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      fireAuth.sendPasswordResetEmail(email: email);

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) =>
      fireAuth.confirmPasswordReset(code: code, newPassword: newPassword);
}
