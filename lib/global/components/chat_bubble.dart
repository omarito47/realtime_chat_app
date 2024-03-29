
import 'package:flutter/material.dart';
import 'package:chat_app/global/utils/global.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(ConstantHelper.sizex12)
      ),
      padding:  EdgeInsets.all(ConstantHelper.sizex16),
      margin:  EdgeInsets.symmetric(vertical: 2.5,horizontal: ConstantHelper.sizex25),
      child: Text(message,style: const TextStyle(color: Colors.white),),
    );
  }
}
