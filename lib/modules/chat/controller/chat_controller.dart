
import 'package:chat_app/global/utils/global.dart';


class ChatController {
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  String extractUsernameFromEmail(String email) {
    List<String> parts = email.split('@');
    String username = parts[0];
    username = username.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return username;
  }

  Future<void> sendMessage(String receiverID, String message) async {
    if (message.isNotEmpty) {
      await chatService.sendMessage(receiverID, message);
    }
  }

  Future<void> sendEmoji(String receiverID) async {
    await chatService.sendMessage(receiverID, "👍");
  }

  String getCurrentUserID() {
    return authService.getCurrentUser()!.uid;
  }
}