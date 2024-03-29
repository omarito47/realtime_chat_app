import 'package:agora_uikit/agora_uikit.dart';
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
  late final AgoraClient client;

  @override
  void initState() {
    super.initState();
 
    initAgora();
  }

  void initAgora() async {
    String agoraApiKey = dotenv.env['AGORA_API_KEY']! ;
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: agoraApiKey,
        channelName: widget.channelName,
        username: widget.userName,
      ),
    );
    await client.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.oneToOne,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false, // Add this to enable screen sharing
            ),
          ],
        ),
      ),
    );
  }
}
