import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCallModel {
  String roomId;
  String initiatorId;
  String receiverId;
  String status;
  Timestamp timeStamp;
  VideoCallModel(
      {required this.roomId,
      required this.initiatorId,
      required this.receiverId,
      required this.status,
      required this.timeStamp});
  static VideoCallModel get empty=> VideoCallModel(
      roomId: '1',
      initiatorId: "1",
      receiverId: '1',
      status: '',
      timeStamp: Timestamp.now());
  factory VideoCallModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      if (snapshot.exists) {
        final data = snapshot.data();
        return VideoCallModel(
            roomId: data['roomId'],
            initiatorId: data['initiatorId'],
            receiverId: data['receiverId'],
            status: data['status'],
            timeStamp: data['timeStamp']);
      } else {
        return VideoCallModel.empty;
      }
    } catch (e) {
      throw "Erro converting to VideocallModel ${e.toString()}";
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'initiatorId': initiatorId,
      "status": status,
      "receiverId": receiverId,
      'timeStamp': timeStamp,
      "roomId": roomId
    };
  }

  factory VideoCallModel.fromMap(Map<String, dynamic> map) {
    return VideoCallModel(
        roomId: map["roomId"],
        initiatorId: map["initiatorId"],
        receiverId: map["receiverId"],
        status: map["status"],
        timeStamp: Timestamp.now()
        );
  }
}
