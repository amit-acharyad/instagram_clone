import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String postId;
  final String userId;
  LikeModel({required this.postId, required this.userId});
  static LikeModel empty() => LikeModel(postId: '', userId: '');
  factory LikeModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data();
      return LikeModel(postId: data?['postId'], userId: data?['userId']);
    } else {
      return LikeModel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {'postId': postId, 'userId': userId};
  }
}
