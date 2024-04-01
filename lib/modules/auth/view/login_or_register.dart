import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => LoginOrRegisterState();
}

class LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  // toggle between login and register
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
