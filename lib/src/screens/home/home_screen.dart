import 'package:flutter/material.dart';

import '../../widgets/profile_button.dart';
import '../edit_bill/edit_bill_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitsi'),
        actions: const [
          ProfileButton(),
        ],
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.restorablePushNamed(
                  context,
                  EditBillScreen.routeName,
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New bill'),
            ),
          ],
        ),
      ),
    );
  }
}
