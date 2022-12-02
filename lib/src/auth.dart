import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Auth extends ChangeNotifier {
  Auth() {
    init();
  }

  bool get signedIn => _signedIn;
  bool _signedIn = false;

  String? get name => FirebaseAuth.instance.currentUser?.displayName;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _signedIn = true;
      } else {
        _signedIn = false;
      }
      notifyListeners();
    });
  }
}
