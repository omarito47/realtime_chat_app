import 'package:chat_app/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        //backgroundColor: Colors.red,
        // foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        title: Text(ConstantHelper.homeText),
      ),
      body: _homeController.buildUserList(),
      drawer: const MyDrawer(),
    );
  }
}
