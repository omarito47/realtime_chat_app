import 'package:chat_app/global/services/firebase/firebase_service.dart';

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
          _authService.getCurrentUser()!.email; 
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
  } 

  @override
  void initState() {
    super.initState();
    _loadImageUrl(); 
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
                              radius: ConstantHelper.sizex20*2,
                            )
                          : GestureDetector(
                              onTap: _uploadImage,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: ConstantHelper.sizex20*2,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: ConstantHelper.sizex20*2,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                        height:
                            ConstantHelper.sizex08), 
                    Text(
                      userName ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: ConstantHelper.sizex16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
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
