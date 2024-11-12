import 'dart:async';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/data/repositories/userrepository.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final AgoraClient client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: "8968a1f23a43418291ffcec57c69c89e",
          channelName: "videocallinstaclone",
          username: UserController.instance.user.value.name,
          tempToken:
              "007eJxTYHi7xzx34z3PLjXTXU0mHBu+qkz0m/nmxf5rmzgzzvPHNlxQYLCwNLNINEwzMk40MTYxtDCyNExLS05NNjVPNrNMtrBMtUj+m9YQyMiwtHIFEyMDBIL4wgxlmSmp+cmJOTmZecUlick5+XmpDAwA2vQnKg=="),
      enabledPermission: [
        Permission.audio,
        Permission.camera,
        Permission.microphone
      ]);
  final VideoCallController videoCallController =
      Get.put(VideoCallController());
  void initState() {
    super.initState();
    initAgora();
    videoCallController.startCall();
  }

  void initAgora() async {
    await client.initialize();
  }

  void dispose() {
    videoCallController.endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoViewer(
            client: client,
            layoutType: Layout.floating,
            enableHostControls: true,
          ),
          AgoraVideoButtons(
            client: client,
            addScreenSharing: true,
            extraButtons: [
              Obx(() => Text(
                  "${videoCallController.callDuration.value.inMinutes}:${videoCallController.callDuration.value.inSeconds}"))
            ],
            enabledButtons: [
              BuiltInButtons.callEnd,
              BuiltInButtons.switchCamera,
              BuiltInButtons.toggleMic
            ],
          ),
        ],
      ),
    );
  }
}

class VideoCallController extends GetxController {
  DateTime? startTime;
  Timer? timer;
  Rx<Duration> callDuration = Duration.zero.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startCall();
  }

  void startCall() {
    startTime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      callDuration.value = DateTime.now().difference(startTime!);
      print(callDuration.value);
    });
  }

  void endCall() {
    timer!.cancel();
    print("total duration is ${callDuration.value.inMinutes}");
  }

  @override
  void dispose() {
    print("disposee at ${DateTime.now()}");
    endCall();
    super.dispose();
  }
}
