import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/utils/resources/app_text.dart';

class LoginController {
  LoginController(this.emailController, this.passwordController, this.context);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final BuildContext context;

  String errorMessage = '';

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (_) {
      errorMessage = AppText.errorMessage;
    }
  }
}
