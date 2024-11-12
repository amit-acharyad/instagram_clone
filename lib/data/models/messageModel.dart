import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String message;
  String senderId;
  String receiverId;
  Timestamp timeStamp;
  bool seen;
  String messageId;
  MessageModel(
      {required this.message,
      required this.messageId,
      required this.senderId,
      required this.receiverId,
      required this.seen,
      required this.timeStamp});
  static MessageModel empty() => MessageModel(
      seen: false,
      messageId: '',
      message: '',
      senderId: '',
      receiverId: '',
      timeStamp: Timestamp.now());
  factory MessageModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      return MessageModel(
          seen: data["seen"],
          messageId: data['messageId'],
          message: data["message"],
          senderId: data['senderId'],
          receiverId: data['receiverId'],
          timeStamp: data['timeStamp']);
    } else {
      return MessageModel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'messageId':messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamp': timeStamp,
      'seen': seen
    };
  }
}
