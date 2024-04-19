import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwControlller = TextEditingController();
  void login(BuildContext context) async {

    final authService = AuthService();
   
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _pwControlller.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
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
              size: ConstantHelper.sizex20*3,
              color: Theme.of(context).colorScheme.primary,
            ),
             SizedBox(
              height: ConstantHelper.sizex20+ConstantHelper.sizex10,
            ),

            
            Text(
              'Welcome Back, you\'ve been missed',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: ConstantHelper.sizex14,
              
              ),
            ),
             SizedBox(
              height: ConstantHelper.sizex20,
            ),
    
            CustomTextFiled(
              hintText: "Email",
              obsucureText: false,
              controller: _emailController,
            ),
             SizedBox(
              height: ConstantHelper.sizex10,
            ),
          
            CustomTextFiled(
              hintText: "Password",
              obsucureText: true,
              controller: _pwControlller,
            ),
             SizedBox(
              height: ConstantHelper.sizex25,
            ),
           
            CustomButton(onTap: () =>login(context) , text: "Login"),
             SizedBox(
              height: ConstantHelper.sizex25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
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
