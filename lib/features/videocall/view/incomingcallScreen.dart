import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/homescreen.dart';
import '../../profile/data/model/usermodel.dart';
import '../controller/videoCallChecker.dart';
import '../controller/webRTCVideoCallController.dart';
import 'webRTCVideoCallScreen.dart';

class IncomingCallScreen extends StatelessWidget {
  IncomingCallScreen({super.key});
  final WebRTCVideoCallController webRTCVideoCallController =
      Get.put(WebRTCVideoCallController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Caller Photo
          FutureBuilder(
              future: getUser(VideoCallChecker.currentCall.value.initiatorId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final caller = snapshot.data;
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(caller!.photoUrl),
                      ),
                      const SizedBox(height: 20),
                      // Caller Name
                      Text(
                        caller.name, // Replace with actual caller name
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),

          const SizedBox(height: 40),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle Call Receive
                  print("Call Received");
                  Get.to(WebRTCVideoCallScreen(
                    receiverId: "1",
                    roomId: VideoCallChecker.currentCall.value.roomId,
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(Icons.call, color: Colors.white, size: 30),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Handle Call Reject
                  await webRTCVideoCallController.updateDocStatus(
                      VideoCallChecker.currentCall.value.initiatorId, "ended");
                  // VideoCallChecker.currentCall.value = VideoCallModel.empty;
                  Get.offAll(HomeScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(Icons.call_end, color: Colors.white, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<UserModel> getUser(String uid) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();
    final user = UserModel.fromSnapshot(snapshot);
    return user;
  } catch (e) {
    throw "Could not fetch user ${e.toString()}";
  }
}
