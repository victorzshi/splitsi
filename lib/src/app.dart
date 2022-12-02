import 'package:flutter/material.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'screens/edit_bill/edit_bill_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/view_bill/view_bill_screen.dart';

/// Handle navigation between screens. Uses FirebaseUI for sign-in flows.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitsi - Bill Splitting App',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      routes: {
        '/sign-in': ((context) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction(((context, email) {
                Navigator.of(context)
                    .pushNamed('/forgot-password', arguments: {'email': email});
              })),
              AuthStateChangeAction(((context, state) {
                if (state is SignedIn || state is UserCreated) {
                  var user = (state is SignedIn)
                      ? state.user
                      : (state as UserCreated).credential.user;
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@').first);
                  }
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
              })),
            ],
          );
        }),
        '/forgot-password': ((context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'] as String,
            headerMaxExtent: 200,
          );
        }),
        '/profile': (context) {
          return ProfileScreen(
            appBar: AppBar(
              title: const Text('Splitsi'),
            ),
            actions: [
              SignedOutAction((context) {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
            ],
          );
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == HomeScreen.routeName) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => const HomeScreen(),
          );
        }

        if (settings.name == HistoryScreen.routeName) {
          final uid = Provider.of<Auth>(context, listen: false).uid;

          return MaterialPageRoute(
            settings: settings,
            builder: (context) => HistoryScreen(uid: uid),
          );
        }

        if (settings.name == EditBillScreen.routeName) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => const EditBillScreen(),
          );
        }

        // Handle '/bills/:code'
        final uri = Uri.parse(settings.name ?? '');
        final path = ViewBillScreen.routeName.replaceFirst(RegExp(r'/'), '');
        if (uri.pathSegments.first == path && uri.pathSegments.length == 2) {
          final code = uri.pathSegments[1];
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => ViewBillScreen(code: code),
          );
        }

        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return Scaffold(
              body: Center(
                child: Text('${settings.name} not found'),
              ),
            );
          },
        );
      },
    );
  }
}
