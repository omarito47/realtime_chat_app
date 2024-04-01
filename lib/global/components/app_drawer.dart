import 'package:chat_app/global/services/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  File? _imageFile;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  String? userName;

  Future<void> _uploadImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });

      final userEmail =
          _authService.getCurrentUser()!.email; // Replace with the user's email
      final imageUrl =
          await _firebaseService.uploadImageToFirebase(_imageFile!, userEmail!);

      if (imageUrl != null) {
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    }
  }

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  } // Rest of the code...

  @override
  void initState() {
    super.initState();
    _loadImageUrl(); // Load the image URL when the drawer initializes
  }

  Future<void> _loadImageUrl() async {
    var userEmail = _authService.getCurrentUser()!.email;

    final imageUrl = await _firebaseService.getImageFromFirebase(userEmail!);
    if (imageUrl != null) {
      setState(() {
        _imageUrl = imageUrl;
      });
    }
    setState(() {
      userName = extractUsernameFromEmail(userEmail);
    });
  }

  // extract name from the email
  String extractUsernameFromEmail(String email) {
    // Split the email address using the '@' symbol
    List<String> parts = email.split('@');

    // The username is the first part of the split result
    String username = parts[0];

    // Remove any non-alphanumeric characters from the username
    username = username.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Center(
                      child: _imageUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(_imageUrl!),
                              radius: 40,
                            )
                          : GestureDetector(
                              onTap: _uploadImage,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: 40,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: ConstantHelper.sizex40,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                        height:
                            8), // Add spacing between the CircleAvatar and Text
                    Text(
                      userName ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // home list tile
              Padding(
                padding: EdgeInsets.only(left: ConstantHelper.sizex25),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.home,
                      color: Theme.of(context).colorScheme.primary),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // settings list tile
              Padding(
                padding: EdgeInsets.only(left: ConstantHelper.sizex25),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.settings,
                      color: Theme.of(context).colorScheme.primary),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ));
                  },
                ),
              ),
            ],
          ),
          // logout list tile
          Padding(
            padding: EdgeInsets.only(
                left: ConstantHelper.sizex25, bottom: ConstantHelper.sizex25),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.primary),
              onTap: () {
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
