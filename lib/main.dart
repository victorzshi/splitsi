import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';
import 'src/app.dart';
import 'src/auth_provider.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    builder: ((context, child) => const App()),
  ));
}
