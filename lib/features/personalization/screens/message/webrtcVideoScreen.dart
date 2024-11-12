import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/videocallModel.dart';
import 'package:instagram_clone/features/personalization/controllers/webRtcVideoController.dart';
import 'package:instagram_clone/features/personalization/controllers/webRtcVideoService.dart';
import 'package:instagram_clone/features/personalization/screens/navigationscreen.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

class WebRtcVideoScreen extends StatefulWidget {
  WebRtcVideoScreen(
      {super.key, required this.videoCall, required this.receiverId});
  VideoCallModel? videoCall = VideoCallModel.empty();
  String? receiverId;
  @override
  State<WebRtcVideoScreen> createState() => _WebRtcVideoScreenState();
}

class _WebRtcVideoScreenState extends State<WebRtcVideoScreen> {
  WebrtcVideoService webrtcVideoService = WebrtcVideoService();
  RTCVideoRenderer localVideo = RTCVideoRenderer();
  RTCVideoRenderer remoteVideo = RTCVideoRenderer();
  String? roomId;
  RxBool muted = false.obs;
  RxBool videoEnabled = true.obs;
  Rx<Duration> durationOfCall = Duration.zero.obs;

  Timer? timer;
  @override
  void initState() {
    localVideo.initialize();
    remoteVideo.initialize();
    webrtcVideoService.onAddRemoteStream = ((stream) {
      remoteVideo.srcObject = stream;
      setState(() {});
    });
    muted.value = localVideo.muted;
    asyncFunc();
    super.initState();
  }

  void toggleMuteAudio() {
    localVideo.srcObject?.getAudioTracks().forEach((track) {
      track.enabled = !muted.value; // Enable/disable audio track
      muted.value = !muted.value;
    });
  }

  void togglevideo() {
    localVideo.srcObject?.getVideoTracks().forEach((track) {
      videoEnabled.value = !videoEnabled.value;
      track.enabled = videoEnabled.value;
    });
  }

  Future<void> asyncFunc() async {
    try {
      print("now getting media");
      print("call ended ${WebRTCVideoController.instance.callEnded.value}");
      await webrtcVideoService.openUserMedia(localVideo, remoteVideo);
      print("Got media");

      if (widget.videoCall == null) {
        throw "videoCall is null";
      }

      if (widget.receiverId == null) {
        throw "receiverId is null";
      }
      print("Widget initiator id is ${widget.videoCall!.initiatorId}");

      // print(
      //     "remoteVideo${remoteVideo.srcObject} and its tracks ${remoteVideo.srcObject!.getTracks().isEmpty}");
      if (widget.videoCall!.initiatorId == '1') {
        print("now creating room ");
        final newroomId = await webrtcVideoService.createRoom(remoteVideo);
        print("roomCreated with id $newroomId ");
        setState(() {
          roomId = newroomId;
        });
        await WebRTCVideoController.instance
            .addDoc(widget.receiverId!, roomId!);

        // await webrtcVideoService.joinRoom(roomId!, remoteVideo);
      } else {
        print("inside the case which receives roomId");
        final newroomId = widget.videoCall!.roomId;
        setState(() {
          roomId = newroomId;
        });
        await webrtcVideoService.joinRoom(roomId!, remoteVideo);
      }
      // print(
      // "remoteVideo${remoteVideo.srcObject} and its tracks ${remoteVideo.srcObject!.getTracks().isEmpty}");
      // if (durationOfCall.value.inMinutes == 1 &&

      DateTime startTime = DateTime.now();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        durationOfCall.value = DateTime.now().difference(startTime);
        print(durationOfCall.value);
      });
      checkRemoteStreamAfterTimeout();
    } catch (e) {
      throw "Error occured in async func ${e.toString()}";
    }
  }

  void checkRemoteStreamAfterTimeout() {
    Future.delayed(const Duration(seconds: 20), () {
      // If the remote stream is still null, end the call
      print("delay 20 sec obver");
      print("${remoteVideo.srcObject}");
      if (remoteVideo.srcObject == null) {
        print("condition true");
        onEndCall();
      }
    });
  }

  @override
  void dispose() {
    localVideo.dispose();
    remoteVideo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body: 
      Obx(
        () {
        final videoCall = WebRTCVideoController.instance.videoCall.value;
        print(" video call is ${videoCall.toJson()}");
        final callended = WebRTCVideoController.instance.callEnded.value;
        print("callEnded is $callended");
        bool condition4 = webrtcVideoService.peerConnection?.signalingState ==
            RTCSignalingState.RTCSignalingStateClosed;
        bool connectionstatus1 =
            webrtcVideoService.peerConnection?.connectionState ==
                RTCPeerConnectionState.RTCPeerConnectionStateDisconnected;
        bool connectionstatus2 =
            webrtcVideoService.peerConnection?.connectionState ==
                RTCPeerConnectionState.RTCPeerConnectionStateClosed;

        bool connectionstatus3 =
            webrtcVideoService.peerConnection?.connectionState ==
                RTCPeerConnectionState.RTCPeerConnectionStateFailed;
        print(
            "1$connectionstatus1 2$connectionstatus2 3$connectionstatus3 4$condition4");
        if (connectionstatus1 ||
            connectionstatus2 ||
            connectionstatus3 ||
            condition4) {
          // timer!.cancel();
          webrtcVideoService.hangUp(localVideo);

          return SizedBox(
              height: AppHelperFunctions.screenHeight(context),
              width: AppHelperFunctions.screenWidth(context),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton.filled(
                        onPressed: () {
                          Get.offAll(const NavigationBarScreen());
                        },
                        icon: const Icon(Icons.close_outlined)),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Call Ended"),
                  ),
                ],
              ));
        }

        return Stack(
          children: [
            // Video Container
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
              child: RTCVideoView(
                localVideo,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                mirror: true,
              ),
            ),

            // Remote Video
            remoteVideo.srcObject != null
                ? Positioned(
                    top: 0,
                    right: 15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: AppHelperFunctions.screenHeight(context) * 0.6,
                        width: AppHelperFunctions.screenWidth(context) * 0.55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: RTCVideoView(
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          remoteVideo,
                          placeholderBuilder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),

            // Control Buttons
            Positioned(
              bottom: 10, // Adjust the bottom padding as needed
              left: 0,
              right: 0, // Make the row span the width of the container
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        toggleMuteAudio();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30, // Adjust the radius as needed
                        child: Icon(
                          (!muted.value) ? Icons.mic : Icons.mic_off,

                          color: Colors.black,
                          size: 24, // Adjust the size as needed
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await onEndCall();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 30, // Adjust the radius as needed
                        child: Icon(
                          Icons.call_end,

                          color: Colors.white,
                          size: 36, // Adjust the size as needed
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        togglevideo();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30, // Adjust the radius as needed
                        child: Icon(
                          (videoEnabled.value)
                              ? Icons.videocam
                              : Icons.videocam_off,

                          color: Colors.black,
                          size: 24, // Adjust the size as needed
                        ),
                      ),
                    ),
                    Text(
                        "${durationOfCall.value.inMinutes}:${(durationOfCall.value.inSeconds) % 60}")
                  ],
                );
              }),
            ),
          ],
        );
      })),
    );
  }

  Future<void> onEndCall() async {
    try {
      timer!.cancel();
      webrtcVideoService.hangUp(localVideo);

      if (widget.videoCall!.initiatorId == '1' || widget.videoCall == null) {
        await WebRTCVideoController.instance
            .updateDocStatus(widget.receiverId!, status['2']);
      } else {
        await WebRTCVideoController.instance
            .updateDocStatus(widget.videoCall!.initiatorId, status['2']);
      }

      Get.offAll(const NavigationBarScreen());
    } catch (e) {
      throw "Could not end call${e.toString()}";
    }
  }
}

class ControlButtons extends StatelessWidget {
  const ControlButtons(
      {super.key,
      required this.muted,
      required this.onEndCall,
      required this.onMuteToggle,
      required this.onSwitchCamera});
  final bool muted;
  final Function onMuteToggle;
  final Function onEndCall;
  final Function onSwitchCamera;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            icon: muted ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
            color: Colors.green,
            onPressed: () => onMuteToggle),
        ElevatedButton(
          onPressed: () => onEndCall,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Icon(
            Icons.call_end,
            size: 36,
          ),
        ),
        IconButton(
            icon: const Icon(Icons.switch_camera),
            color: Colors.blue,
            onPressed: () => onSwitchCamera),
      ],
    );
  }
}
