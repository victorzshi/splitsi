import 'package:flutter/material.dart';

import '../bills/create_bill_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitsi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 64),
            const SizedBox(height: 32),
            const Text(
              'Splitsi is the fastest and easiest way to split bills.',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.restorablePushNamed(
                  context,
                  CreateBillScreen.routeName,
                );
              },
              child: const Text('Create a bill'),
            ),
          ],
        ),
      ),
    );
  }
}
