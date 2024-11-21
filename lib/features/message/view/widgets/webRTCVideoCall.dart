// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get.dart';
// import 'package:instagram_clone/data/models/videocallModel.dart';
// import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
// import 'package:instagram_clone/features/videocall/controllers/webRtcVideoController.dart';
// import 'package:instagram_clone/utils/helpers/helper_functions.dart';

// class WebRTCVideoCall extends StatelessWidget {
//   WebRTCVideoCall(
//       {super.key, required this.receiverId, required this.videoCallModel});
//   String receiverId;
//   VideoCallModel videoCallModel;

//   @override
//   Widget build(BuildContext context) {
//     print("Passing receiver $receiverId");
//     final WebRTCVideoController webRTCVideoController =
//         Get.put(WebRTCVideoController(receiverId: receiverId));
//     return SafeArea(
//         child: Scaffold(
//             body: Stack(
//       children: [
//         SizedBox(
//           height: AppHelperFunctions.screenHeight(context),
//           width: AppHelperFunctions.screenWidth(context),
//           child: webRTCVideoController.remoteVideo.srcObject!=null
//               ? RTCVideoView(webRTCVideoController.remoteVideo)
//               : CachedNetworkImage(
//                   imageUrl:
//                       AuthenticationRepository.instance.authUser!.photoURL!),
//         ),
//         Positioned(
//             top: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: SizedBox(
//                   height: 200,
//                   width: 150,
//                   child: webRTCVideoController.videoEnabled.value
//                       ? RTCVideoView(webRTCVideoController.localVideo)
//                       : CachedNetworkImage(
//                           imageUrl: AuthenticationRepository
//                               .instance.authUser!.photoURL!),
//                 ),
//               ),
//             )),

//         // Control Buttons
//         Positioned(
//           bottom: 10, // Adjust the bottom padding as needed
//           left: 0,
//           right: 0, // Make the row span the width of the container
//           child: Obx(() {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     webRTCVideoController.toggleMuteAudio();
//                   },
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 30, // Adjust the radius as needed
//                     child: Icon(
//                       (!webRTCVideoController.muted.value)
//                           ? Icons.mic
//                           : Icons.mic_off,

//                       color: Colors.black,
//                       size: 24, // Adjust the size as needed
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () async {
//                     await webRTCVideoController.onEndCall();
//                   },
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.red,
//                     radius: 30, // Adjust the radius as needed
//                     child: Icon(
//                       Icons.call_end,

//                       color: Colors.white,
//                       size: 36, // Adjust the size as needed
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     webRTCVideoController.togglevideo();
//                   },
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 30, // Adjust the radius as needed
//                     child: Icon(
//                       (webRTCVideoController.videoEnabled.value)
//                           ? Icons.videocam
//                           : Icons.videocam_off,

//                       color: Colors.black,
//                       size: 24, // Adjust the size as needed
//                     ),
//                   ),
//                 ),
//                 // Text(
//                 //     "${durationOfCall.value.inMinutes}:${(durationOfCall.value.inSeconds) % 60}")
//               ],
//             );
//           }),
//         ),
//       ],
//     )));
//   }
// }
