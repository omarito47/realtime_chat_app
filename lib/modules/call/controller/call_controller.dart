import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CallController {
  late final AgoraClient client;

  Future<void> initAgora(String channelName, String userName) async {
    String agoraApiKey = dotenv.env['AGORA_API_KEY']!;
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: agoraApiKey,
        channelName: channelName,
        username: userName,
      ),
    );
    await client.initialize();
  }
}