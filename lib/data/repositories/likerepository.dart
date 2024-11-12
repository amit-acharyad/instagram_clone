import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/likemodel.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';

class LikeRepository extends GetxController {
  static LikeRepository get instance => Get.find();
  final String currentUserId = AuthenticationRepository.instance.authUser!.uid;
  Stream<List<String>> getLikeStream(String postId) {
    try {
      final likeStream = FirebaseFirestore.instance
          .collection("Likes")
          .where('postId', isEqualTo: postId)
          .snapshots();  
      final usersWhoLikedPost = likeStream.map((stream) => stream.docs
          .map((like) => LikeModel.fromSnapshot(like).userId)
          .toList());
      return usersWhoLikedPost;
    } catch (e) {
      throw "Error getting like stream";
    }
  }

  Future<List<String>> fetchLikes() async {
    try {
      // final data = FirebaseFirestore.instance
      //     .collection("Likes")
      //     .where('userId', isEqualTo: currentUserId)
      //     .snapshots();
      // final likesModels = data.map((snapshot) => snapshot.docs
      //     .map((likeData) => LikeModel.fromSnapshot(likeData))
      //     .toList());
      // final likedPosts = likesModels
      //     .map((likeModel) => likeModel.map((like) => like.postId).toList());
      final data = await FirebaseFirestore.instance.collection("Likes").get();
      final likeModels =
          data.docs.map((like) => LikeModel.fromSnapshot(like)).toList();
      final likedPosts = likeModels
          .where((likeModel) => likeModel.userId == currentUserId)
          .map((likeModel) => likeModel.postId)
          .toList();
      return likedPosts;
    } catch (e) {
      throw "Error fetching likes";
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final LikeModel likeModel =
          LikeModel(postId: postId, userId: currentUserId);
      await FirebaseFirestore.instance
          .collection("Likes")
          .doc()
          .set(likeModel.toJson());
    } catch (e) {
      throw "Could not like";
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("Likes")
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: currentUserId)
          .get();
      await doc.docs.first.reference.delete();
      print("Unliked");
    } catch (e) {
      throw "Could not unlike";
    }
  }
}
