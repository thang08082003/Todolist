import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist/utils/resources/app_text.dart';
import 'package:todolist/view_model/controllers/login_controller.dart';
import 'package:todolist/views/widgets/commons_widget/logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.showRegisterScreen, super.key});

  final VoidCallback showRegisterScreen;

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<VoidCallback>.has(
        'showRegisterScreen',
        showRegisterScreen,
      ),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController =
        LoginController(_emailController, _passwordController, context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                  const LogoWidget(),
                  const SizedBox(height: 30),
                  const Text(
                    AppText.appName,
                    style: TextStyle(fontSize: 32, color: Colors.black),
                  ),
                  const Text(
                    AppText.welcomeMessage,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 50),
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
                    child: ElevatedButton(
                      onPressed: () async {
                        await _loginController.signIn();
                        setState(
                          () {},
                        );
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
                          AppText.signInButtonText,
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
                  if (_loginController.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        _loginController.errorMessage,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        AppText.registerPrompt,
                        style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterScreen,
                        child: const Text(
                          AppText.registerLinkText,
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
