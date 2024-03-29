import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CustomButton({super.key,required this.onTap,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(ConstantHelper.sizex08),
        ),
        padding:  EdgeInsets.all(ConstantHelper.sizex25),
        margin:  EdgeInsets.symmetric(horizontal: ConstantHelper.sizex25),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
