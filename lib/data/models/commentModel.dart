import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String postId;
  final String userId;
  final Timestamp time;
  final String comment;
  final String commentId;
  CommentModel(
      {required this.postId,
      required this.userId,
      required this.time,
      required this.comment,
      required this.commentId});
  static CommentModel empty() => CommentModel(
      comment: '',
      commentId: '',
      postId: '',
      userId: '',
      time: Timestamp.fromDate(DateTime.now()));
  factory CommentModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data();
      return CommentModel(
          postId: data['postId'],
          userId: data['userId'],
          time: data['time'],
          comment: data['comment'],
          commentId: data['commentId']);
    } else {
      return CommentModel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'time': time,
      'comment': comment,
      'commentId': commentId
    };
  }
}
