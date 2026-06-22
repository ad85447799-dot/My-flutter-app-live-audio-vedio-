import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "95817857d6cce14d17563fef46cf2d4da7a56b9076cebe171ddcb2f284d98ccc";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoCallPage(),
    );
  }
}

class VideoCallPage extends StatefulWidget {
  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, uid) {
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (connection, uid) {
          setState(() => _remoteUid = uid);
        },
      ),
    );
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(token: null, channelId: "test", uid: 0, options: ChannelMediaOptions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Video Room')),
      body: Center(
        child: _localUserJoined 
          ? Text('Camera ON ✅ Room: test') 
          : Text('Joining...'),
      ),
    );
  }
}
