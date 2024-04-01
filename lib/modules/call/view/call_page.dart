import 'package:agora_uikit/agora_uikit.dart';
import 'package:chat_app/modules/call/controller/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class AgoraVideoChatWidget extends StatefulWidget {
  final String channelName;
  final String userName;

  const AgoraVideoChatWidget({
    Key? key,
    required this.channelName,
    required this.userName,
  }) : super(key: key);

  @override
  State<AgoraVideoChatWidget> createState() => _AgoraVideoChatWidgetState();
}

class _AgoraVideoChatWidgetState extends State<AgoraVideoChatWidget> {
  late final CallController callController;

  @override
  void initState() {
    super.initState();
    callController = CallController();
    callController.initAgora(widget.channelName, widget.userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: callController.client,
              layoutType: Layout.oneToOne,
              enableHostControls: true,
            ),
            AgoraVideoButtons(
              client: callController.client,
              addScreenSharing: false,
            ),
          ],
        ),
      ),
    );
  }
}