import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../auth.dart';
import '../../screens/history/history_screen.dart';
import '../edit_bill/edit_bill_screen.dart';

/// Default screen. All screens should be able to navigate back to home.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Splitsi'),
            actions: [
              if (provider.signedIn)
                TextButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(
                      context,
                      HistoryScreen.routeName,
                    );
                  },
                  child: const Text('History'),
                ),
              if (provider.signedIn)
                TextButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(context, '/profile');
                  },
                  child: const Text('Profile'),
                ),
              if (!provider.signedIn)
                TextButton(
                  onPressed: () {
                    Navigator.restorablePushNamed(context, '/sign-in');
                  },
                  child: const Text('Sign in'),
                ),
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
      },
    );
  }
}
