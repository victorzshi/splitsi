import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    init();
  }

  bool get signedIn => _signedIn;
  bool _signedIn = false;

  // TODO: Add user collection in database.
  String? get name => FirebaseAuth.instance.currentUser?.displayName;

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _signedIn = true;
      } else {
        _signedIn = false;
      }
      notifyListeners();
    });
  }
}
