import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist/views/screens/login_screen/login_screen.dart';
import 'package:todolist/views/screens/register_screen/register_screen.dart';
import 'package:todolist/views/widgets/commons_widget/bottom_bar_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const BottomBarWidget();
          } else {
            if (showLoginScreen) {
              return LoginScreen(showRegisterScreen: toggleScreens);
            } else {
              return RegisterScreen(showLoginScreen: toggleScreens);
            }
          }
        },
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<bool>(
        'showLoginScreen',
        showLoginScreen,
      ),
    );
  }
}
