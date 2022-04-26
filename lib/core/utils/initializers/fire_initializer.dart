import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class FireInitializer {
  static final _initializer = Completer();

  static Future get waiter => _initializer.future;

  static Future mainInit() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
    } catch (e) {
      _initializer.completeError(e);
      rethrow;
    }
    _initializer.complete();
  }
}
