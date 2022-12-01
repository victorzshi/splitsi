import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../firebase_options.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    init();
  }

  bool get signedIn => _signedIn;
  bool _signedIn = false;

  // TODO: Add user collection in database.
  String? get name => FirebaseAuth.instance.currentUser?.displayName;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );

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
