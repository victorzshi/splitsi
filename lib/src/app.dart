import 'package:flutter/material.dart';

import 'bills/create_bill_screen.dart';
import 'home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitsi - Bill Splitting App',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      routes: {
        CreateBillScreen.routeName: (context) {
          return const CreateBillScreen();
        },
        // TODO: View specific bill, e.g. /bills/XYZA
      },
    );
  }
}
