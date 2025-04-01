import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/utils/resources/app_text.dart';

class RegisterController {
  RegisterController(
    this.emailController,
    this.passwordController,
    this.confirmedPasswordController,
    this.context,
    this.nameController,
  );

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmedPasswordController;
  final TextEditingController nameController;
  final BuildContext context;

  String? firebaseError;
  String? successMessage;
  String? photoURL;

  Future<void> signUp() async {
    if (passwordConfirmed()) {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await saveUserData(userCredential.user);

        successMessage = AppText.registrationSuccess;
        firebaseError = null;

        _showSnackBar(successMessage);
      } on FirebaseAuthException catch (_) {
        firebaseError = AppText.registrationError;
        successMessage = null;
        _showSnackBar(firebaseError);
      }
    } else {
      firebaseError = AppText.passwordMismatchError;
      successMessage = null;
      _showSnackBar(firebaseError);
    }
  }

  Future<void> saveUserData(User? user) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
        'uid': user.uid,
        'name': nameController.text.trim(),
        'email': user.email,
        'photoURL': photoURL,
      });
    }
  }

  bool passwordConfirmed() =>
      passwordController.text.trim() == confirmedPasswordController.text.trim();

  void _showSnackBar(String? message) {
    if (message != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void setProfileImageUrl(String url) {
    photoURL = url;
  }
}
