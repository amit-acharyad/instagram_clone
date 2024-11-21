import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import '../controller/videoCallChecker.dart';
import '../controller/webRTCVideoCallController.dart';
import '../model/videocallModel.dart';

class WebRTCVideoCallScreen extends StatefulWidget {
  WebRTCVideoCallScreen(
      {super.key, required this.receiverId, required this.roomId});
  String receiverId;
  String roomId;

  @override
  State<WebRTCVideoCallScreen> createState() => _WebRTCVideoCallScreenState();
}

class _WebRTCVideoCallScreenState extends State<WebRTCVideoCallScreen> {
  RTCVideoRenderer localVideoRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  final WebRTCVideoCallController webRTCVideoCallController =
      Get.put(WebRTCVideoCallController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // VideoCallChecker.callStatus.value = '1';
    localVideoRenderer.initialize();
    remoteRenderer.initialize();
    webRTCVideoCallController.webRTCVideoService.onAddRemoteStream =
          ((stream) {
        remoteRenderer.srcObject = stream;
        setState(() {});
      });
    ever(VideoCallChecker.currentCall, (VideoCallModel call) {
      print(
          "initiator is inside ever  ${VideoCallChecker.currentCall.value.initiatorId}");
      if (call.status == "ended") {
        print("ended + started by others");
        webRTCVideoCallController.onEndCall(localVideoRenderer);
        // VideoCallChecker.currentCall.value = VideoCallModel.empty;
      }
    });
    asyncFun();
  }

  asyncFun() async {
    try {
    await  webRTCVideoCallController.webRTCVideoService
          .openUserMedia(localVideoRenderer, remoteRenderer);
      setState(() {});
      webRTCVideoCallController.muted.value = localVideoRenderer.muted;
      setState(() {
        
      });
      
      if (widget.roomId == '1' && widget.receiverId != "1") {
        var room = await webRTCVideoCallController.webRTCVideoService
            .createRoom(remoteRenderer);
        setState(() {
          
        });
        await webRTCVideoCallController.addDoc(widget.receiverId, room);
      }
      if (widget.receiverId == "1" && widget.roomId != "1") {
        await webRTCVideoCallController.webRTCVideoService
            .joinRoom(widget.roomId, remoteRenderer);
            setState(() {
              
            });
      }
      
    } catch (e) {
      throw "Error ${e.toString()}";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    localVideoRenderer.dispose();
    remoteRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final WebRTCVideoCallController webRTCVideoCallController = Get.put(
    //   WebRTCVideoCallController(
    //     receiverId: widget.receiverId,
    //     roomId: widget.roomId,
    //   ),
    //   // tag: UniqueKey().toString()
    // );
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: RTCVideoView(
              remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              placeholderBuilder: (context) => ColoredBox(color: Colors.green),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 250,
                width: 150,
                child: RTCVideoView(
                  localVideoRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  mirror: true,
                  placeholderBuilder: (context) =>
                      ColoredBox(color: Colors.blue),
                ),
              ),
            ),
          ),
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
                      webRTCVideoCallController
                          .toggleMuteAudio(localVideoRenderer);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30, // Adjust the radius as needed
                      child: Icon(
                        (webRTCVideoCallController.muted.value)
                            ? Icons.mic
                            : Icons.mic_off,

                        color: Colors.black,
                        size: 24, // Adjust the size as needed
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      VideoCallModel videoCallModel =
                          VideoCallChecker.currentCall.value;
                      print(" this is current video call before ending ${videoCallModel.toJson()}");
                      VideoCallChecker.currentCall.value = VideoCallModel(
                          roomId: videoCallModel.roomId,
                          initiatorId: videoCallModel.initiatorId,
                          receiverId: videoCallModel.receiverId,
                          status: "ended",
                          timeStamp: videoCallModel.timeStamp);
                      // await webRTCVideoCallController
                      //     .onEndCall(localVideoRenderer);
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
                      webRTCVideoCallController.togglevideo(localVideoRenderer);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30, // Adjust the radius as needed
                      child: Icon(
                        (webRTCVideoCallController.videoEnabled.value)
                            ? Icons.videocam
                            : Icons.videocam_off,

                        color: Colors.black,
                        size: 24, // Adjust the size as needed
                      ),
                    ),
                  ),
                  // Text(
                  //     "${durationOfCall.value.inMinutes}:${(durationOfCall.value.inSeconds) % 60}")
                ],
              );
            }),
          ),
        ],
      )),
    );
  }
}
