import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist/services/image_services.dart';
import 'package:todolist/utils/resources/app_text.dart';
import 'package:todolist/view_model/controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.showLoginScreen, super.key});

  final VoidCallback showLoginScreen;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<VoidCallback>.has(
        'showLoginScreen',
        showLoginScreen,
      ),
    );
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final ImageService _imageService = ImageService();
  XFile? _selectedImage;

  late RegisterController _registerController;

  @override
  void initState() {
    super.initState();
    _registerController = RegisterController(
      _emailController,
      _passwordController,
      _confirmedPasswordController,
      context,
      _nameController,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imageService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    if (_selectedImage == null) {
      return null;
    }
    return _imageService.uploadImageToFirebase(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(File(_selectedImage!.path))
                          : null,
                      child: _selectedImage == null
                          ? const Icon(Icons.add_a_photo, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    AppText.appName,
                    style: TextStyle(fontSize: 32, color: Colors.black),
                  ),
                  const Text(
                    AppText.registerMessage,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: AppText.nameHint,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: AppText.emailHint,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: AppText.passwordHint,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _confirmedPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: AppText.confirmPasswordHint,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ElevatedButton(
                      onPressed: () async {
                        final String? imageUrl = await _uploadImageToFirebase();
                        if (imageUrl != null) {
                          _registerController.setProfileImageUrl(imageUrl);
                        }
                        await _registerController.signUp();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          AppText.signUpButtonText,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_registerController.firebaseError != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        _registerController.firebaseError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_registerController.successMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        _registerController.successMessage!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        AppText.alreadyHaveAccount,
                        style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginScreen,
                        child: const Text(
                          AppText.loginLinkText,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
