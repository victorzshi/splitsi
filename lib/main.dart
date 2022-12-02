import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';
import 'src/app.dart';
import 'src/auth.dart';
import 'src/models/account.dart';
import 'src/models/bill.dart';
import 'src/models/comment.dart';
import 'src/models/expense.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  if (kDebugMode) {
    AccountService.setTestData();
    CommentService.setTestData();
    BillService.setTestData();
    ExpenseService.setTestData();
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => Auth(),
    builder: ((context, child) => const App()),
  ));
}
