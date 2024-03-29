import 'package:chat_app/global/services/firebase/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  final FirebaseService _firebaseService = FirebaseService();

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

  Future<String?> loadImageUrl(email) async {
    final imageUrl = await _firebaseService.getImageFromFirebase(email!);
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: _buildUserList(),
      drawer: const MyDrawer(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // return a list of users
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build individual list tile for user
 Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
  if (userData["email"] != _authService.getCurrentUser()!.email) {
    return FutureBuilder<String?>(
      future: loadImageUrl(userData["email"]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return UserTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(
                      receiverEmail: userData["email"],
                      receiverID: userData["uid"],
                    );
                  },
                ),
              );
            },
            text: extractUsernameFromEmail(userData["email"]),
            
          );
        } else if (snapshot.hasError) {
          return Text("Error");
        } else {
          final imgUrl = snapshot.data;
          return UserTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(
                      receiverEmail: userData["email"],
                      receiverID: userData["uid"],
                    );
                  },
                ),
              );
            },
            text: extractUsernameFromEmail(userData["email"]),
            imageUrl: imgUrl,
          );
        }
      },
    );
  } else {
    return Container();
  }
}
}
