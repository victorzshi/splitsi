import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../firebase_options.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    init();
  }

  User? get user => _user;
  User? _user;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    });
  }
}
