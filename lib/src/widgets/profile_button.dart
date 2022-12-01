import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../auth_provider.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        if (provider.user != null) {
          return TextButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, '/profile');
            },
            child: const Text('Profile'),
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
