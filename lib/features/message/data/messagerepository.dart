
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/message/data/messageModel.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:rxdart/rxdart.dart';

class MessageRepository extends GetxController {
  static MessageRepository messageRepository = Get.find();
  String currentUserId = AuthenticationRepository.instance.authUser!.uid;

  Future<void> sendMessage(String message, String receiverId) async {
    try {
      final messageId = DateTime.now().microsecondsSinceEpoch.toString();
      final MessageModel messageModel = MessageModel(
          message: message,
          senderId: currentUserId,
          seen: false,
          receiverId: receiverId,
          messageId: messageId,
          timeStamp: Timestamp.now());
      await FirebaseFirestore.instance
          .collection('Messages')
          .doc(messageId)
          .set(messageModel.toJson());
    } catch (e) {
      throw "Error sending message ${e.toString()} ";
    }
  }

  Stream<List<MessageModel>> getMessageStream(String senderId) {
    try {
      final snapshots = FirebaseFirestore.instance
          .collection("Messages")
          .where('receiverId', isEqualTo: currentUserId)
          .where('senderId', isEqualTo: senderId)
          .orderBy('timeStamp')
          .snapshots();
      final otherSnapshots = FirebaseFirestore.instance
          .collection("Messages")
          .where('receiverId', isEqualTo: senderId)
          .where('senderId', isEqualTo: currentUserId)
          .orderBy('timeStamp')
          .snapshots();
      final message1Stream = snapshots.map((stream) => stream.docs
          .map((message) => MessageModel.fromSnapshot(message))
          .toList());
      final message2Stream = otherSnapshots.map((stream) => stream.docs
          .map((message) => MessageModel.fromSnapshot(message))
          .toList());
      final messageStream = CombineLatestStream.combine2(
          message1Stream, message2Stream, (messages1, messages2) {
        List<MessageModel> combinedMessage = [];
        combinedMessage = messages1 + messages2;
        combinedMessage.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
        return combinedMessage;
      });
      return messageStream;
    } catch (e) {
      throw "error getiing stream";
    }
  }

  Stream<List<String>> getMessageFriends() {
    try {
      final streamMessage = FirebaseFirestore.instance
          .collection("Messages")
          .where('receiverId', isEqualTo: currentUserId)
          .snapshots();
      final messageFriends = streamMessage.map((stream) => stream.docs
          .map((data) => MessageModel.fromSnapshot(data).senderId)
          .toSet());
      final streamMessage2 = FirebaseFirestore.instance
          .collection("Messages")
          .where('senderId', isEqualTo: currentUserId)
          .snapshots();
      final messageFriends2 = streamMessage2.map((stream) => stream.docs
          .map((data) => MessageModel.fromSnapshot(data).receiverId)
          .toSet());
      final combinedStream = CombineLatestStream.combine2(
          messageFriends, messageFriends2, (messageFriend, messageFriend2) {
        List<String> combined = [];
        combined = messageFriend.toList() + messageFriend2.toList();
                

        return combined;
      });
      return combinedStream;
    } catch (e) {
      throw "Error getting messsage Users Stream ${e.toString()}";
    }
  }

  Future<void> updateSeen(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Messages")
          .doc(docId)
          .update({'seen': true});
    } catch (e) {
      throw "eerror updating seen ${e.toString()}";
    }
  }
}
