import 'dart:async';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final AgoraClient client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: "your app Id",
          channelName: "channelName",
          username: UserController.instance.user.value.name,
          tempToken:
              "agora-token"),
      enabledPermission: [
        Permission.audio,
        Permission.camera,
        Permission.microphone
      ]);
  final VideoCallController videoCallController =
      Get.put(VideoCallController());
  @override
  void initState() {
    super.initState();
    initAgora();
    videoCallController.startCall();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
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
            enabledButtons: const [
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
