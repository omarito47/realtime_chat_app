import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => RregisterStatePage();
}

class RregisterStatePage extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwControlller = TextEditingController();
  final TextEditingController _confirmPwControlller = TextEditingController();
  // register function
  void register(BuildContext context) {
    final _auth = AuthService();

    if (_pwControlller.text == _confirmPwControlller.text) {
      try {
        _auth.signUpWithEmailAndPassword(
          _emailController.text,
          _pwControlller.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder:(context) =>  AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    else{
      showDialog(
          context: context,
          builder:(context) =>  AlertDialog(
            title: Text("Passwords don't match!"),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: ConstantHelper.sizex60,
              color: Theme.of(context).colorScheme.primary,
            ),
             SizedBox(
              height: ConstantHelper.sizex30,
            ),

            // welcome back message
            Text(
              'Let\'s create an account for you',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: ConstantHelper.sizex14,
                // fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(
              height: ConstantHelper.sizex20,
            ),
            // email textFiled
            CustomTextFiled(
              hintText: "Email",
              obsucureText: false,
              controller: _emailController,
            ),
             SizedBox(
              height: ConstantHelper.sizex10,
            ),
            // password textFiled
            CustomTextFiled(
              hintText: "Password",
              obsucureText: true,
              controller: _pwControlller,
            ),
             SizedBox(
              height: ConstantHelper.sizex10,
            ),
            // confirm password textfiled
            CustomTextFiled(
              hintText: "Confirm password",
              obsucureText: true,
              controller: _confirmPwControlller,
            ),
             SizedBox(
              height: ConstantHelper.sizex25,
            ),
            // register button
            CustomButton(onTap: () => register(context), text: "Register"),
             SizedBox(
              height: ConstantHelper.sizex25,
            ),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
