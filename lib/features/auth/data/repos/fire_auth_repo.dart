import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mivent/core/exceptions/auth.dart';
import 'package:mivent/core/utils/initializers/fire_initializer.dart';
import 'package:mivent/features/auth/data/models/user_model.dart';
import 'package:mivent/features/auth/data/models/user_type_model.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/auth/domain/repos/auth_repo.dart';
import 'package:mivent/features/auth/domain/repos/user_store.dart';

class FireAuth extends IAuth {
  FireAuth(this.userStore);
  final IUserStore userStore;

  static FirebaseAuth? _fireAuth;
  static FirebaseFirestore? _fireStore;

  static DocumentReference<Map<String, dynamic>> get userCollection =>
      _fireStore!.collection('users').doc(_fireAuth!.currentUser!.uid);

  @override
  UserType get type => userStore.type;

  @override
  set type(UserType val) => userStore.saveType(val);

  Future ensureInit() async {
    await FireInitializer.waiter;
    _fireAuth ??= FirebaseAuth.instance;
    _fireStore ??= FirebaseFirestore.instance;
  }

  Future<UserData> _getUserData(User user) async {
    await ensureInit();
    var data = await userCollection.get();
    return UserModel.fromMap({
      'id': user.uid,
      'email': user.email!,
      'name': user.displayName!,
      'image_url': user.photoURL,
      'type': UserTypeModel.fromString(data['type']),
    });
  }

  @override
  Future<UserData?> getUpdatedUser() async {
    await ensureInit();
    var user = _fireAuth!.currentUser;
    if (user != null) return await _getUserData(_fireAuth!.currentUser!);
    return null;
  }

  @override
  Future<UserData> signIn(String email, String password) async {
    await ensureInit();
    var credential = await _fireAuth!
        .signInWithEmailAndPassword(email: email, password: password);

    return _getUserData(credential.user!);
  }

  @override
  Future<UserData?> signInWithGoogle() async {
    await ensureInit();
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
        await _fireStore!
            .collection('users')
            .doc(user.uid)
            .set({'type': type.toString()});
      }

      return _getUserData(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        var methods = await _fireAuth!.fetchSignInMethodsForEmail(e.email!);
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
    await ensureInit();
    var user = (await _fireAuth!
            .createUserWithEmailAndPassword(email: email, password: password))
        .user!;

    await _fireStore!
        .collection('users')
        .doc(user.uid)
        .set({'type': type.toString()});

    user.updateDisplayName(extraData['name'] as String);

    return UserModel.fromMap(
        {'id': user.uid, 'type': type, 'email': email, ...extraData});
  }

  @override
  Future<void> signOut() => _fireAuth!.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await ensureInit();
    return _fireAuth!.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) =>
      _fireAuth!.confirmPasswordReset(code: code, newPassword: newPassword);
}
