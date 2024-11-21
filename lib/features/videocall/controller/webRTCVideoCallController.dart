import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import '../../authentication/data/authenticationrepository.dart';
import '../model/videocallModel.dart';
import '../view/callEndScreen.dart';
import 'videoCallChecker.dart';
import 'webRTCVIdeoService.dart';

Map<String, dynamic> status = {
  '0': 'initiated',
  '1': 'accepted',
  '2': 'ended',
};

class WebRTCVideoCallController extends GetxController {
  final currentUserId = AuthenticationRepository.instance.authUser!.uid;
  final WebRTCVideoService webRTCVideoService = WebRTCVideoService();
  static WebRTCVideoCallController get instance => Get.find();
  // Rx<RTCVideoRenderer> localVideoRenderer = RTCVideoRenderer().obs;
  // Rx<RTCVideoRenderer> remoteVideoRender = RTCVideoRenderer().obs;
  RxBool muted = false.obs;
  RxBool videoEnabled = true.obs;
  // WebRTCVideoCallController({this.receiverId, this.roomId});
  // String? receiverId;
  // String? roomId;
  void toggleMuteAudio(RTCVideoRenderer localVideoRenderer) {
    localVideoRenderer.srcObject?.getAudioTracks().forEach((track) {
      track.enabled = !muted.value; // Enable/disable audio track
      muted.value = !muted.value;
    });
  }

  void togglevideo(RTCVideoRenderer localVideoRenderer) {
    localVideoRenderer.srcObject?.getVideoTracks().forEach((track) {
      videoEnabled.value = !videoEnabled.value;
      track.enabled = videoEnabled.value;
    });
  }

  @override
  void onClose() {
    VideoCallChecker.currentCall.value = VideoCallModel.empty;
    super.onClose();
  }

  @override
  void onInit() async {
    print("Initializing controller");
    super.onInit();
    // localVideoRenderer.value.initialize();
    // remoteVideoRender.value.initialize();
    // webRTCVideoService.onAddRemoteStream = ((stream) {
    //   remoteVideoRender.value.srcObject = stream;
    // });
    // muted.value = localVideoRenderer.value.muted;
    // await webRTCVideoService.openUserMedia(
    //     localVideoRenderer.value, remoteVideoRender.value);
    // if (roomId == '1' && receiverId != "1") {
    //   var room = await webRTCVideoService.createRoom(remoteVideoRender.value);
    //   await addDoc(receiverId!, room);
    // }
    // if (receiverId == "1" && roomId != "1") {
    //   await webRTCVideoService.joinRoom(roomId!, remoteVideoRender.value);
    // }
  }

  Future<void> updateDocStatus(String callerId, String status) async {
    try {
      final docId = concatAndSort(callerId, currentUserId);
      print("doc Id is $docId");
      await FirebaseFirestore.instance
          .collection("VideoCalls")
          .doc(docId)
          .update({'status': status});
    } catch (e) {
      throw "Error updating doc ${e.toString()}";
    }
  }

  Future<void> addDoc(String receiverId, String roomId) async {
    try {
      final docId = concatAndSort(currentUserId, receiverId);
      final VideoCallModel videoCallModel = VideoCallModel(
          roomId: roomId,
          initiatorId: currentUserId,
          receiverId: receiverId,
          status: status['0'],
          timeStamp: Timestamp.now());
      VideoCallChecker.currentCall.value = videoCallModel;
      VideoCallChecker.listenCurrentCall();
      await FirebaseFirestore.instance
          .collection("VideoCalls")
          .doc(docId)
          .set(videoCallModel.toJson());
    } catch (e) {
      throw "Could not add doc${e.toString()}";
    }
  }

  Future<void> deleteDoc(String receiverId) async {
    try {
      final docId = concatAndSort(currentUserId, receiverId);

      await FirebaseFirestore.instance
          .collection("VideoCalls")
          .doc(docId)
          .delete();
    } catch (e) {
      throw "Could not add doc${e.toString()}";
    }
  }

  Future<void> onEndCall(RTCVideoRenderer locaVideoRenderer) async {
    try {
      await webRTCVideoService.hangUp(locaVideoRenderer);
      print(
          "inside end call initiator is ${VideoCallChecker.currentCall.value.initiatorId} receiver is ${VideoCallChecker.currentCall.value.receiverId}}");
      print("current user is ${currentUserId}");
      if (VideoCallChecker.currentCall.value.initiatorId == currentUserId) {
        print("updating by caller");
        await updateDocStatus(
            VideoCallChecker.currentCall.value.receiverId, status['2']);
      } else {
        print("Updating by receiver");
        await updateDocStatus(
            VideoCallChecker.currentCall.value.initiatorId, status['2']);
      }
      onClose();
      Get.to(CallEndScreen());
      VideoCallChecker.currentCall.value = VideoCallModel.empty;
    } catch (e) {
      throw "Could not end call${e.toString()}";
    }
  }
}

String concatAndSort(String str1, String str2) {
  // Concatenate the two strings
  String combined = str1 + str2;

  // Convert the combined string to a list of characters
  List<String> charList = combined.split('');

  // Sort the list of characters alphabetically
  charList.sort();

  // Join the sorted characters back into a string
  return charList.join('');
}
