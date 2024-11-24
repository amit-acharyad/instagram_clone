import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/posts/data/model/postmodel.dart';
import 'package:instagram_clone/features/posts/data/repository/postrepository.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/posts/controllers/likecontroller.dart';
import 'package:instagram_clone/navigationscreen.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';
import 'package:instagram_clone/utils/popups/loaders.dart';

class Postcontroller extends GetxController {
  static Postcontroller get instance => Get.find();
  RxList<XFile?> image = <XFile?>[].obs;
  final String userId = AuthenticationRepository.instance.authUser!.uid;
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isUploadingPost = false.obs;
  final RxBool isLoadingPosts = false.obs;
  final postCollection = FirebaseFirestore.instance.collection("Posts");
  final postDatabase = FirebaseStorage.instance.ref("Posts/userPosts");
  final captionController = TextEditingController();
  late LikeController likeController;
  final Postrepository postrepository = Get.put(Postrepository());
  RxList<PostModel> ownPosts = <PostModel>[].obs;
  RxList<String> ownPostIds = <String>[].obs;

  @override
  void onInit() async {
    print("Now fetching all posts");
    await fetchAllPosts();
    super.onInit();
  }

  Future<void> post() async {
    try {
      final postImage = await uploadPhoto();
      final post = PostModel(
          userId: userId,
          postId: AppHelperFunctions.generatePostId(userId),
          caption: captionController.text.trim(),
          postTime: Timestamp.fromDate(DateTime.now()),
          commentsCount: 0,
          likesCount: 0,
          postImage: postImage);
      isUploadingPost.value = true;
      await postCollection.doc(post.postId).set(post.toJson());
      AppLoaders.successSnackBar(
          title: "Post added Successfully", message: "All good mate");
      Get.to(const NavigationBarScreen());
    } catch (e) {
      AppLoaders.errorSnackBar(title: "Error", message: "Something went Wrong");
      throw "Something went Wromg!!";
    } finally {
      isUploadingPost.value = false;
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      isLoadingPosts.value = true;
      print("fetching posts");
      final snapshot =
          await FirebaseFirestore.instance.collection("Posts").get();
      print('snapshot receive now onto mapping');
      final snapshots =
          snapshot.docs.map((snapshot) => PostModel.fromSnapshot(snapshot));
      posts.assignAll(snapshots.toList());
      print("posts fetched and assigned Successfully");
      ownPosts.assignAll(posts
          .where((post) =>
              post.userId == AuthenticationRepository.instance.authUser!.uid)
          .toList());
      ownPostIds.assignAll(ownPosts.map((ownPost) => ownPost.postId));
    } catch (e) {
      throw "Could not fetch posts $e";
    } finally {
      isLoadingPosts.value = false;
    }
  }

  Future<String> uploadPhoto() async {
    try {
      final imgFile = File(image[0]!.path);
      final child = Timestamp.now().millisecondsSinceEpoch;
      TaskSnapshot uploadTask = await postDatabase
          .child(child.toString())
          .putFile(imgFile)
          .onError((e, __) {
        print(e.toString());
        throw (e.toString());
      });

      // Check if the upload was successful
      if (uploadTask.state == TaskState.success) {
        // Get the download URL after successful upload
        String downloadURL =
            await postDatabase.child(child.toString()).getDownloadURL();

        return downloadURL; // Return the download URL if needed
      } else {
        return 'failed';
      }
    } catch (e) {
      throw "Could not upload photo";
    }
  }
}
