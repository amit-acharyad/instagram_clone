import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/followmodel.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';

class Followrepository extends GetxController {
  // RxList<String> followers = [''].obs;
  // RxList<String> following = [''].obs;
  static Followrepository get instance => Get.find();
  FirebaseFirestore followsDb = FirebaseFirestore.instance;
  Followrepository({required this.currentUserId});
  final String currentUserId;
  final authUid = AuthenticationRepository.instance.authUser!.uid;
 
  // onInit() async {
  //   super.onInit();
  //   await fetchFollowersFollowing();
  // }

  // Future<void> fetchFollowersFollowing() async {
  //   try {
  //     final snapshots = await followsDb.collection("Follow").get();
  //     final follow = snapshots.docs
  //         .map((snapshot) => FollowModel.fromSnapshot(snapshot))
  //         .toList();
  //     print('Total follows models=${follow.length}');
  //     print('current user is $currentUserId');
  //     final followerModels = follow
  //         .where((followerModel) => followerModel.userId == currentUserId)
  //         .toList();
  //     print('Total follower models=${followerModels.length}');

  //     final followerIds = followerModels.map((follower) => follower.followerId);

  //     final followingModels = follow
  //         .where((follower) => follower.followerId == currentUserId)
  //         .toList();
  //     print('Total following models=${followingModels.length}');

  //     final followingIds = followingModels.map((following) => following.userId);
  //     following.assignAll(followingIds);
  //     followers.assignAll(followerIds);
  //   } catch (e) {
  //     throw "Something went Wrong";
  //   }
  // }

  Future<void> follow() async {
    try {
      final FollowModel followModel =
          FollowModel(userId: currentUserId, followerId: authUid,timeStamp: Timestamp.now());
      await FirebaseFirestore.instance
          .collection("Follow")
          .doc()
          .set(followModel.toJson());
      print("FollowedSuccessfully");
    } catch (e) {
      throw "Could not add followers";
    }
   
  }
   Future<void> unfollow() async {
      try {
        final doc = await FirebaseFirestore.instance
            .collection("Follow")
            .where('userId', isEqualTo: currentUserId)
            .where('followerId', isEqualTo: authUid)
            .get();
        await doc.docs.first.reference.delete();
        print("unfollowed successfully");
      } catch (e) {
        throw "COuld not unfollow";
      }
    }
}
