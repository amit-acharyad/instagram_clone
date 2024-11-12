import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/videocallModel.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/localNotification.dart';

Map<String, dynamic> status = {
  '0': 'initiated',
  '1': 'accepted',
  '2': 'ended',
};

class WebRTCVideoController extends GetxController {
  static WebRTCVideoController get instance => Get.find();
  final currentUser = AuthenticationRepository.instance.authUser?.uid;
  Rx<VideoCallModel> videoCall = VideoCallModel.empty().obs;
  RxBool callEnded = false.obs;
  Rx<String> connectionState = ''.obs;

  @override
  void onInit() {
    getStream();
    super.onInit();
  }

  void getStream() {
    try {
      print("Getting stream");
      final incomingCallSnapshots = FirebaseFirestore.instance
          .collection("VideoCalls")
          .where('status', isEqualTo: status['0'])
          .where('receiverId', isEqualTo: currentUser)
          .limit(1)
          .snapshots();

      incomingCallSnapshots.listen((snapshot) async {
        if (snapshot.docs.isEmpty) {
          print("Empty no docs");
        } else {
          final docSnapshot = snapshot.docs.first;
          videoCall.value = VideoCallModel.fromSnapshot(docSnapshot);
          print("Videocall value Updated");
          print("SHould call notification now");
          await LocalNotificationService.showCallNotification(videoCall.value);
          print(
              "Value is ${videoCall.value.initiatorId}, ${videoCall.value.roomId}");
        }
      });
      final endedCallSnapshots = FirebaseFirestore.instance
          .collection("VideoCalls")
          .where('status', isEqualTo: status['2'])
          .where('roomId', isEqualTo: videoCall.value.roomId)
          .limit(1)
          .snapshots();
      print("listening fir end calls of z${videoCall.value.roomId}");
      endedCallSnapshots.listen((snapshot) {
        if (snapshot.docs.isEmpty) {
          print("No Call End Docs");
        } else {
          callEnded.value = true;
          print("call ended became true");
        }
      });
    } catch (e) {
      throw "Error getting stream ${e.toString()}";
    }
  }

  Future<void> updateDocStatus(String callerId, String status) async {
    try {
      final docId = concatAndSort(callerId, currentUser!);
      await FirebaseFirestore.instance
          .collection("VideoCalls")
          .doc(docId)
          .update({'status': status});
    } catch (e) {
      throw "Error updating doc${e.toString()}";
    }
  }

  Future<void> addDoc(String receiverId, String roomId) async {
    try {
      final docId = concatAndSort(currentUser!, receiverId);
      final VideoCallModel videoCallModel = VideoCallModel(
          roomId: roomId,
          initiatorId: currentUser!,
          receiverId: receiverId,
          status: status['0'],
          timeStamp: Timestamp.now());
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
      final docId = concatAndSort(currentUser!, receiverId);

      await FirebaseFirestore.instance
          .collection("VideoCalls")
          .doc(docId)
          .delete();
    } catch (e) {
      throw "Could not add doc${e.toString()}";
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
