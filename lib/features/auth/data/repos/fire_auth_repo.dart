import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mivent/core/error/failure.dart';

import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/features/auth/data/models/user_model.dart';
import 'package:mivent/features/auth/data/models/user_type_model.dart';
import 'package:mivent/features/auth/domain/failure_causes.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/repos/auth_repo.dart';
import 'package:mivent/features/auth/domain/repos/user_store.dart';
import 'package:mivent/global/data/app_data.dart';

class FireAuth extends IAuth {
  FireAuth(IUserStore userStore) : super(userStore);

  static FirebaseAuth? _fireAuth;
  static FirebaseFirestore? _fireStore;

  ///TODO: provide official support
  static const String accountDisabledText =
      'Your account is disabled. Please contact ${AppSettings.supportEmail} for support';

  static Future _ensureInit() async {
    await FireSetup.waitForInit;
    _fireAuth ??= FirebaseAuth.instance;
    _fireStore ??= FirebaseFirestore.instance;
  }

  static Future<DocumentReference<Map<String, dynamic>>> get userDoc async {
    await _ensureInit();
    return _fireStore!
        .collection(FireConstants.usersCollName)
        .doc(_fireAuth!.currentUser!.uid);
  }

  Future<UserData> _getUserData(User user) async {
    await _ensureInit();
    var data = await (await userDoc).get();
    return UserModel.fromMap({
      'id': user.uid,
      'email': user.email!,
      'display_name': user.displayName!,
      'image_url': user.photoURL,
      'type': UserTypeModel.fromString(data.data()?['type'] ?? ''),
    });
  }

  @override
  Future<UserData?> getRemoteUser() async {
    await _ensureInit();
    var user = _fireAuth!.currentUser;
    if (user != null) return await _getUserData(_fireAuth!.currentUser!);
    return null;
  }

  @override
  Future<Either<Failure, UserData>> signIn(
      String email, String password) async {
    try {
      await _ensureInit();
      var credential = await _fireAuth!
          .signInWithEmailAndPassword(email: email, password: password);
      var user = await _getUserData(credential.user!);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return Left(
            Failure(
                message: 'The email you entered is invalid',
                cause: EmailFailure()),
          );
        case 'user-disabled':
          return Left(
            Failure(message: accountDisabledText, cause: EmailFailure()),
          );
        case 'user-not-found':
          return Left(
            Failure(
                message:
                    'There is no account registered with this email. Sign up instead',
                cause: EmailFailure()),
          );
        case 'wrong-password':
          return Left(
            Failure(
                message:
                    'The password you entered was incorrect. Please try again',
                cause: PasswordFailure()),
          );
        default:
          throw Exception();
      }
    } on Exception catch (_) {
      return const Left(
        Failure(
            message:
                'There was a problem signing you in. Please try again later'),
      );
    }
  }

  @override
  Future<Either<Failure?, UserData>> authWithGoogle(bool newUser) async {
    List? methods;
    try {
      await _ensureInit();
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return const Left(null);

      var methods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(googleUser.email);

      if (methods.isEmpty && !newUser) {
        return const Left(Failure(
            message: "You have not signed up yet. Please do that first"));
      }
      if (methods.isNotEmpty && newUser) {
        return const Left(Failure(
            message:
                "You have already signed up with this email. Please sign in instead"));
      }

      final googleAuth = await googleUser.authentication;
      final credential = await FirebaseAuth.instance
          .signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ));

      if (credential.user == null) throw Exception();
      if (newUser) {
        await (await userDoc)
            .set({'type': type.toString()}, SetOptions(merge: true));
      }
      var user = await _getUserData(credential.user!);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          return const Left(Failure(message: accountDisabledText));
        case 'account-exists-with-different-credential':
          return Left(Failure(
            message: 'Please sign in with: ${methods!
                    .map((e) => e[0].toUpperCase() + e.substring(1))
                    .join(' or ')}',
          ));
        default:
          throw Exception();
      }
    } on Exception catch (_) {
      return const Left(
        Failure(
            message:
                "There was a problem using Google. Please try again later"),
      );
    }
  }

  @override
  Future<Either<Failure, UserData>> signUp(
      String email, String password, Map<String, Object?> extraData) async {
    try {
      await _ensureInit();
      var user = (await _fireAuth!
              .createUserWithEmailAndPassword(email: email, password: password))
          .user!;
      await (await userDoc).set({
        'type': type.toString(),
        ...extraData,
      }, SetOptions(merge: true));
      user.updateDisplayName(extraData['display_name'] as String);

      return Right(UserModel.fromMap({
        'id': user.uid,
        'email': email,
        ...extraData,
        'type': type,
      }));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return const Left(Failure(
              message:
                  "You have already signed up with this email. Please sign in instead"));
        default:
          throw Exception();
      }
    } on Exception catch (_) {
      return const Left(Failure(message: "There was a problem signing you up"));
    }
  }

  @override
  Future<Failure?> signOut() async {
    try {
      await _fireAuth!.signOut();
      return null;
    } on Exception catch (_) {
      return const Failure(message: "There was a problem signing out");
    }
  }

  @override
  Future<Failure?> sendPasswordResetEmail(String email) async {
    try {
      await _ensureInit();
      await _fireAuth!.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'auth/user-not-found':
          return const Failure(
            message:
                "There is no account registered with this email. Sign up instead",
          );
        default:
          throw Exception();
      }
    } on Exception catch (_) {
      return const Failure(
        message:
            "An email could not be sent at this time. Please try again later",
      );
    }
  }

  @override
  Future<Failure?> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _fireAuth!
          .confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'expired-action-code':
          return const Failure(
              message: "This code has expired. Please request a new one");
        case 'invalid-action-code':
          return const Failure(
              message: "This code is invalid. Check it and try again");
        case 'user-disabled':
          return const Failure(message: accountDisabledText);
        case 'user-not-found':
        default:
          throw Exception();
      }
    } on Exception catch (_) {
      return const Failure(message: "Your password could not be confirmed");
    }
    return null;
  }
}
