import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:instagram_clone/features/personalization/data/repositories/userrepository.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/homescreen.dart';
import 'package:instagram_clone/features/personalization/screens/navigationscreen.dart';

import '../../../../data/models/videocallModel.dart';
import '../../controllers/webRtcVideoController.dart';
import 'webrtcVideoScreen.dart';

class IncomingCallScreen extends StatelessWidget {
  final VideoCallModel videoCall;
  final AudioPlayer audioPlayer = AudioPlayer();

  IncomingCallScreen({required this.videoCall});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: FutureBuilder(
          future: UserRepository.instance
              .fetchUserWithGivenId(videoCall.initiatorId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error fetching caller details");
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final caller = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Incoming Call",
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                const SizedBox(height: 20),
                CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(caller!.photoUrl)),
                const SizedBox(height: 20),
                Text(caller.name, style: const TextStyle(fontSize: 20)),
                IconButton(
                    onPressed: () {
                      Get.to(NavigationBarScreen());
                    },
                    icon:const Icon(Icons.home)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => receiveCall(),
                      child: const Icon(Icons.call, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await WebRTCVideoController.instance.updateDocStatus(
                            videoCall.initiatorId, status['2']);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Get.back();
                        });
                      },
                      child: const Icon(Icons.call_end, color: Colors.white),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void receiveCall() async {
    try {
      print("Pressed receive");
      await WebRTCVideoController.instance
          .updateDocStatus(videoCall.initiatorId, status['1']);
      Get.to(WebRtcVideoScreen(videoCall: videoCall, receiverId: ''));

      // Delayed navigation to allow async operations to complete
      // Future.delayed(const Duration(milliseconds: 200), () {
      //   SchedulerBinding.instance.addPostFrameCallback((_) {
      //     Get.offAll(() => WebRtcVideoScreen(
      //           videoCall: videoCall,
      //           receiverId: '',
      //         ));
      //   });
      // });
    } catch (e) {
      print("Error while navigating: ${e.toString()}");
    }
  }
}

// class IncomingCallScreen extends StatefulWidget {
//   final VideoCallModel videoCall;

//   IncomingCallScreen({required this.videoCall});

//   @override
//   _IncomingCallScreenState createState() => _IncomingCallScreenState();
// }

// class _IncomingCallScreenState extends State<IncomingCallScreen> {
//   // AudioPlayer audioPlayer = AudioPlayer();
//   // Timer? callTimer;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // playRingtone();
//   //   // Timer to close pop-up after 60 seconds
//   //   callTimer = Timer(Duration(seconds: 60), () {
//   //     Navigator.of(context).pop(); // Close the pop-up
//   //     // stopRingtone();
//   //   });
//   }

//   // @override
//   // // void dispose() {
//   // //   callTimer?.cancel();
//   // //   // stopRingtone();
//   // //   super.dispose();
//   // // }

//   // void playRingtone() async {
//   //   await audioPlayer.play(AssetSource("assets/sounds/ringtone.mp3"));
//   // }

//   // void stopRingtone() {
//   //   audioPlayer.stop();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black.withOpacity(0.7),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         child: Center(
//           child: FutureBuilder(
//               future: UserRepository.instance
//                   .fetchUserWithGivenId(widget.videoCall.initiatorId),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text("error fetching callerDetails");
//                 }
//                 if (!snapshot.hasData) {
//                   return Text("error no data");
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 final caller = snapshot.data;
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Incoming Call",
//                         style: TextStyle(fontSize: 24, color: Colors.white)),
//                     SizedBox(height: 20),
//                     SizedBox(height: 20),
//                     CircleAvatar(
//                         radius: 50,
//                         backgroundImage:
//                             NetworkImage(caller!.photoUrl)), // Caller image
//                     SizedBox(height: 20),
//                     Text(caller.name, style: TextStyle(fontSize: 20)),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () => receive(),
//                           // onPressed: () {
//                           //   // stopRingtone();
//                           //   print("pressed received");
//                           //   // await WebRTCVideoController.instance.updateDocStatus(
//                           //   //     widget.videoCall.initiatorId, status['1']);
//                           //   SchedulerBinding.instance.addPostFrameCallback((_) {
//                           //     Get.offAll(() => WebRtcVideoScreen(
//                           //           videoCall: widget.videoCall,
//                           //           receiverId: '',
//                           //         ));
//                           //   });
//                           // Get.to(WebRtcVideoScreen(
//                           //   videoCall: widget.videoCall,
//                           //   receiverId: '',
//                           // ));

//                           // Get.back();
//                           // },
//                           child: Icon(Icons.call, color: Colors.white),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green),
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             // stopRingtone();
//                             await WebRTCVideoController.instance
//                                 .updateDocStatus(
//                                     widget.videoCall.initiatorId, status['2']);
//                             WidgetsBinding.instance.addPostFrameCallback((_) {
//                               Get.back();
//                             });
//                           },
//                           child: Icon(Icons.call_end, color: Colors.white),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               }),
//         ),
//       ),
//     );
//   }

//   void receive() {
//     try {
//       print("pressed received");
//       // await WebRTCVideoController.instance.updateDocStatus(
//       //     widget.videoCall.initiatorId, status['1']);
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         Get.offAll(() => WebRtcVideoScreen(
//               videoCall: widget.videoCall,
//               receiverId: '',
//             ));
//       });
//     } catch (e) {
//       print("Error while nav ${e.toString()}");
//       throw "Error ${e.toString()}";
//     }
//   }
// }
