import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/posts/data/model/commentModel.dart';
import 'package:instagram_clone/features/profile/data/model/followmodel.dart';
import 'package:instagram_clone/features/notification/data/notificationModel.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/posts/controllers/postcontroller.dart';
import 'package:rxdart/rxdart.dart';

class NotifcationRepository {
  final String userId = AuthenticationRepository.instance.authUser!.uid;
  final Postcontroller postcontroller = Get.put(Postcontroller());
  Stream<List<NotificationModel>> getFollowStream() {
    final stream = FirebaseFirestore.instance
        .collection("Follow")
        .orderBy('timeStamp')
        .where('userId', isEqualTo: userId)
        .snapshots();
    final streamOfFollowModels = stream.map((stream) => stream.docs
        .map((follow) => FollowModel.fromSnapshot(follow))
        .map((follower) => NotificationModel(
            id: '2',
            time:follower.timeStamp,
            type: 'follow',
            userId: follower.followerId))
        .toList());
    return streamOfFollowModels;
  }

  Stream<List<NotificationModel>> getCommentStream() {
    final stream = FirebaseFirestore.instance
        .collection("Comments")
        .orderBy('time')
        
        .snapshots();
    final commentsStream = stream.map((commentStream) => commentStream.docs
        .map((commentModel) => CommentModel.fromSnapshot(commentModel))
        .where((commentModel) =>
            postcontroller.ownPostIds.contains(commentModel.postId))
        .map((commentModel) => NotificationModel(
            id: '3',
            time: commentModel.time,
            type: "comment",
            postId: commentModel.postId,
            userId: commentModel.userId))
        .toList());
    return commentsStream;
  }

  Stream<List<NotificationModel>> getCombinedNotificationsStream() {
    final followStream = getFollowStream();
    final commentStream = getCommentStream();
   final combinedStream =
    CombineLatestStream<List<NotificationModel>, List<NotificationModel>>(
  [followStream, commentStream],
  (List<List<NotificationModel>> streams) {
    final allNotifications = <NotificationModel>[];
    
    for (var stream in streams) {
      allNotifications.addAll(stream); // Combine all notifications
    }
    
    return allNotifications; // Return combined notifications
  },
);

return combinedStream;

  }
}
