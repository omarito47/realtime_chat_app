import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';

class CustomTextFiled extends StatelessWidget {
  final String hintText;
  final bool obsucureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  const CustomTextFiled({
    super.key,
    required this.hintText,
    required this.obsucureText,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: ConstantHelper.sizex25),
      child: TextField(
        controller: controller,
        obscureText: obsucureText,
        focusNode: focusNode,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }
}
