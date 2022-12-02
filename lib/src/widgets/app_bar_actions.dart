import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../auth.dart';
import '../screens/history/history_screen.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, provider, child) {
        if (provider.signedIn) {
          return Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.restorablePushNamed(
                    context,
                    HistoryScreen.routeName,
                  );
                },
                child: const Text('History'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.restorablePushNamed(context, '/profile');
                },
                child: const Text('Profile'),
              ),
            ],
          );
        }

        return TextButton(
          onPressed: () {
            Navigator.restorablePushNamed(context, '/sign-in');
          },
          child: const Text('Sign in'),
        );
      },
    );
  }
}
