import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

const appId = "31802a75eeaa48849b1e31d726b5ab89";
const channel = "testChannel";

class AgoraMeetingScreen extends StatefulWidget {
  const AgoraMeetingScreen({super.key});

  @override
  State<AgoraMeetingScreen> createState() => _AgoraMeetingScreenState();
}

class _AgoraMeetingScreenState extends State<AgoraMeetingScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool isCameraEnabled = true;
  bool isMicrophoneEnabled = true;
  bool isLocalVideoMaximized = false;
  bool isSharingScreen = false;
  final int _localUid = Random().nextInt(1000);

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    final permissions = await Future.wait([
      Permission.microphone.request(),
      Permission.camera.request(),
    ]);

    if (permissions.any((permission) => permission.isDenied)) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Permissions Required"),
            content:
                const Text("Please allow camera and microphone permissions."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
      return;
    }

    try {
      final String token = await fetchToken(channel, _localUid);

      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        const RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            if (mounted) {
              setState(() {
                _localUserJoined = true;
              });
            }
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            if (mounted) {
              setState(() {
                _remoteUid = remoteUid;
              });
            }
          },
          onUserOffline: (
            RtcConnection connection,
            int remoteUid,
            UserOfflineReasonType reason,
          ) {
            if (mounted) {
              setState(() {
                _remoteUid = null;
              });
            }
          },
        ),
      );

      await _engine.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
      );
      await _engine.enableVideo();
      await _engine.startPreview();

      await _engine.joinChannel(
        token: token,
        channelId: channel,
        uid: _localUid,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      if (mounted) {
        debugPrint("Error initializing Agora: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to initialize Agora: $e")),
        );
      }
    }
  }

  Future<String> fetchToken(String channelName, int uid) async {
    final url = Uri.parse(
      'http://agora-token-server-3fe8an8ao-thang08082003s-projects.vercel.app/access_token?channelName=$channelName&uid=$uid&role=publisher&expireTime=3600',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        throw Exception('Failed to load token');
      }
    } catch (e) {
      throw Exception('Error fetching token: $e');
    }
  }

  Future<void> startScreenSharing() async {
    try {
      if (isSharingScreen) {
        await _engine.stopScreenCapture();
        await _engine.enableLocalVideo(true);
        setState(() {
          isSharingScreen = false;
        });
      } else {
        await _engine.enableLocalVideo(false);
        await _engine.startScreenCapture(
          const ScreenCaptureParameters2(
            captureVideo: true,
            captureAudio: true,
            videoParams: ScreenVideoParameters(
              dimensions: VideoDimensions(width: 1280, height: 720),
              frameRate: 15,
              bitrate: 800,
            ),
          ),
        );
        setState(() {
          isSharingScreen = true;
        });
      }
    } catch (e) {
      debugPrint("Error starting/stopping screen sharing: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Meeting'),
          actions: [
            IconButton(
              icon: Icon(isCameraEnabled ? Icons.videocam : Icons.videocam_off),
              onPressed: () async {
                setState(() {
                  isCameraEnabled = !isCameraEnabled;
                });
                await _engine.enableLocalVideo(isCameraEnabled);
              },
            ),
            IconButton(
              icon: Icon(isMicrophoneEnabled ? Icons.mic : Icons.mic_off),
              onPressed: () async {
                setState(() {
                  isMicrophoneEnabled = !isMicrophoneEnabled;
                });
                await _engine.muteLocalAudioStream(!isMicrophoneEnabled);
              },
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch),
              onPressed: () async {
                await _engine.switchCamera();
              },
            ),
            IconButton(
              icon: Icon(
                isSharingScreen ? Icons.stop_screen_share : Icons.screen_share,
              ),
              onPressed: startScreenSharing,
            ),
          ],
        ),
        body: Stack(
          children: [
            ColoredBox(
              color: Colors.white,
              child: Center(
                child: _remoteVideo(),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLocalVideoMaximized = !isLocalVideoMaximized;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isLocalVideoMaximized
                      ? MediaQuery.of(context).size.width
                      : 100,
                  height: isLocalVideoMaximized
                      ? MediaQuery.of(context).size.height
                      : 150,
                  child: _localVideo(),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _localVideo() {
    if (!_localUserJoined) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isSharingScreen || isCameraEnabled) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      );
    }

    return const Center(child: Text("Camera is Off"));
  }

  Widget _remoteVideo() {
    if (_remoteUid == null) {
      return const Center(
        child: Text(
          'No remote user joined',
          textAlign: TextAlign.center,
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: const RtcConnection(channelId: channel),
      ),
    );
  }
}
