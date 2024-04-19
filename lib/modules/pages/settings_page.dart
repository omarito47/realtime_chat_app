import 'package:chat_app/global/utils/constant_helper.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
          centerTitle: true,
          title: Text(ConstantHelper.settings),
          leading: IconButton(
              icon:const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.pop(context);
              })),
    );
  }
}
