import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String userId;
  final String postId;
  final String caption;
  final String postImage;
  final Timestamp postTime;
  final int likesCount;
  final int commentsCount;
  PostModel(
      {required this.userId,
      required this.postId,
      required this.caption,
      required this.postTime,
      required this.commentsCount,
      required this.likesCount,
      required this.postImage});
  static PostModel empty() => PostModel(
      userId: '',
      postId: '',
      caption: '',
      postTime: Timestamp.fromDate(DateTime.now()),
      commentsCount: 0,
      likesCount: 0,
      postImage: '');
  factory PostModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data();
      return PostModel(
          userId: data?['userId'],
          postId: data?['postId'],
          caption: data?['caption'],
          postTime: data?['postTime'],
          commentsCount: data?['commentsCount'],
          likesCount: data?['likesCount'],
          postImage: data?['postImage']);
    } else {
      return PostModel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'userId':userId,
      'postId':postId,
      'caption':caption,
      'postTime':postTime,
      'commentsCount':commentsCount,
      'likesCount':likesCount,
      'postImage':postImage
    };
  }
}
