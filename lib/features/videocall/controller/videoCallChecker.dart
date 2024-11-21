import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../authentication/data/authenticationrepository.dart';
import '../model/videocallModel.dart';

Map<String, dynamic> status = {
  '0': 'initiated',
  '1': 'accepted',
  '2': 'ended',
};

class VideoCallChecker {
  static final currentUserId = AuthenticationRepository.instance.authUser!.uid;
  static  Rx<VideoCallModel> currentCall = VideoCallModel.empty.obs;
  static Rx<String> callStatus = '1'.obs;
  static getIncomingVideoCall() {
    FirebaseFirestore.instance
        .collection("VideoCalls")
        .where('receiverId', isEqualTo: currentUserId)
        .where('status', isEqualTo: status['0'])
        .snapshots()
        .listen((stream) {
      if (stream.docs.isNotEmpty) {
        currentCall.value = VideoCallModel.fromSnapshot(stream.docs.first);
        // listenCurrentCall();
      }
    });
  }

  static listenCurrentCall() {
    print(
        "Listening to roomId ${currentCall.value.roomId} status is ${currentCall.value.status}");
    FirebaseFirestore.instance
        .collection("VideoCalls")
        .where('roomId', isEqualTo: currentCall.value.roomId)
        .snapshots()
        .listen((stream) {
      if (stream.docs.isNotEmpty) {
        print("Stream for roomId ${currentCall.value.roomId}");
        VideoCallModel video = VideoCallModel.fromSnapshot(stream.docs.first);
        if (video.status == "ended") {
          if (currentCall.value.status != "ended") {
            currentCall.value = video;
          }

          print(
              "Listening to roomId ${currentCall.value.roomId} status is ${currentCall.value.status}");
          print(
              "Video status just ended should now redirect to ending process");
          // currentCall.value = VideoCallModel.empty;
          // callStatus.value = "ended";
          // if (!(video.initiatorId ==
          //     AuthenticationRepository.instance.user!.uid)) {
          //   WebRTCVideoCallController.instance.onEndCall();
          // }
        }
      }
    });
  }
}
