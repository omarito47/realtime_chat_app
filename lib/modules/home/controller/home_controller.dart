import 'package:chat_app/global/services/firebase/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';
class HomeController {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final FirebaseService _firebaseService = FirebaseService();

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

  Widget buildUserList() {
    return StreamBuilder(
      
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
     
        if (snapshot.hasError) {
          return  Text(ConstantHelper.errorText);
        }
     
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        
        return ListView(
          
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

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
            return Text(ConstantHelper.errorText);
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