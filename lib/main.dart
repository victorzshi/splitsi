import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/app.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  runApp(const App());
}
