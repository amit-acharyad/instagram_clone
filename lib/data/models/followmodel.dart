import 'package:cloud_firestore/cloud_firestore.dart';

class FollowModel {
  final String userId;
  final String followerId;
  final Timestamp timeStamp;
  FollowModel({required this.userId, required this.followerId,required this.timeStamp});
  static FollowModel empty() => FollowModel(userId: '', followerId: '',timeStamp: Timestamp.now());
  factory FollowModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data();
      return FollowModel(
          userId: data?['userId'], followerId: data?['followerId'],timeStamp: data?['timeStamp']);
    } else {
      return FollowModel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'followerId': followerId,'timeStamp':timeStamp};
  }
}
