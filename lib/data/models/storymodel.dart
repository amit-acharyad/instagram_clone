import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';

class Storymodel {
  final String userName;
  final String userId;
  final String userImage;
  final Timestamp uploadTime;
  final String storyImage;
  final String storyId;

  Storymodel(
      {required this.userImage,
      required this.storyImage,
      required this.uploadTime,
      required this.storyId,
      required this.userId,
      required this.userName});
  static Storymodel empty() {
    final UserController userController = UserController.instance;
   String userImg = '';
    if (userController.user.value.photoUrl.isNotEmpty) {
      userImg = userController.user.value.photoUrl;
    }
    return Storymodel(
        userImage: userImg.isNotEmpty
            ? userImg
            : "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
        storyId: '0',
        storyImage:
            "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
        uploadTime: Timestamp.fromDate(DateTime.now()),
        userId: '',
        userName: '');
  }

  factory Storymodel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data();
      return Storymodel(
          userImage: data?['userImage'],
          storyId: data?['storyId'],
          storyImage: data?['storyImage'],
          uploadTime: data?['uploadTime'],
          userId: data?['userId'],
          userName: data?['userName']);
    } else {
      print("Returning empty");
      return Storymodel.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'userImage': userImage,
      'userId': userId,
      'storyId': storyId,
      'uploadTime': uploadTime,
      'userName': userName,
      'storyImage': storyImage,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Storymodel && other.storyId == storyId;
  }

  @override
  int get hashCode {
    return storyId.hashCode;
  }
}
