import 'package:chat_app/modules/chat/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/global/utils/global.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final TextEditingController _messageController = TextEditingController();

  Future<void> sendMessage() async {
    
    if (_messageController.text.isNotEmpty) {
      await ChatController().sendMessage(widget.receiverID, _messageController.text);
      scrollDown();
      _messageController.clear();
    }
  }

  // send emojie as a message
  Future<void> sendEmojie() async {
    ChatController().sendEmoji(widget.receiverID);
    scrollDown();
  }

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 40,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: Text(
            ChatController().extractUsernameFromEmail(widget.receiverEmail)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: ConstantHelper.sizex14),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgoraVideoChatWidget(
                            channelName: ChatController()
                                .chatService
                                .getChannelId(widget.receiverID),
                            userName: widget.receiverEmail),
                      ));
                },
                icon: Icon(Icons.video_call)),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = ChatController().authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream:
          ChatController().chatService.getMessage(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
      
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Loading ..."),
          );
        }
  
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) {
            Future.delayed(
              const Duration(milliseconds: 500),
              () => scrollDown(),
            );
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // is currrent user
    bool isCurrentUser =
        data["senderID"] == ChatController().authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // Convert the timestamp to DateTime
    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
      data["timestamp"].seconds * 1000,
    );
    // Convert the timestamp to DateTime
    timestamp = DateTime.fromMillisecondsSinceEpoch(
      data["timestamp"].seconds * 1000,
    );

    // Format the DateTime to desired format (YYYY/MM/DD HH:MM)
    String formattedTimestamp =
        DateFormat('yyyy/MM/dd HH:mm').format(timestamp);

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ConstantHelper.sizex16),
            margin: EdgeInsets.symmetric(
                vertical: ConstantHelper.sizex02,
                horizontal: ConstantHelper.sizex16),
            child: Text(
              formattedTimestamp,
              style: TextStyle(
                fontSize:
                    ConstantHelper.sizex12, 
                color: Colors.grey, 
              ),
            ),
          ),
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: ConstantHelper.sizex20+ConstantHelper.sizex10),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFiled(
              hintText: 'Type a message',
              obsucureText: false,
              controller: _messageController,
              focusNode: focusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            margin: EdgeInsets.only(right: ConstantHelper.sizex10),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: sendMessage,
            ),
          ),
        
          Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            margin: EdgeInsets.only(right: ConstantHelper.sizex25),
            child: IconButton(
              icon: const Icon(Icons.thumb_up),
              onPressed: sendEmojie,
            ),
          ),
        ],
      ),
    );
  }
}
