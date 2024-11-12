import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/data/models/storymodel.dart';
import 'package:instagram_clone/data/models/storyviewer.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/popups/loaders.dart';

class StoryRepository extends GetxController {
  static StoryRepository get instance => Get.find();
  final UserController userController = Get.put(UserController());
  final storyRef = FirebaseStorage.instance.ref("Story");
  final timeLimit = DateTime.now().subtract(Duration(hours: 24));
  final String user = AuthenticationRepository.instance.authUser!.uid;
  RxBool viewedOwnStory = false.obs;
  Stream<Storymodel> fetchOwnStory() {
    try {
      print("fetch own story in repo");
      print("user if in storyrepo $user");
      final snapshot = FirebaseFirestore.instance
          .collection("Stories")
          .where('uploadTime', isGreaterThan: Timestamp.fromDate(timeLimit))
          .where('userId', isEqualTo: user)
          .snapshots();
      print("Got snapshot");
      final ownStoryStream = snapshot.map((stream) => stream.docs
          .map((storyModel) => Storymodel.fromSnapshot(storyModel))
          .toList()
          .first);
      final viewedStory = viewedStoryIds();
      final Stream<bool> ownViewStream =
          CombineLatestStream.combine2(ownStoryStream, viewedStory,
              (Storymodel story, List<String> viewedStory) {
        return viewedStory.contains(story.storyId);
      });
      ownViewStream.listen((stream) {
        viewedOwnStory.value = stream;
      });
      return ownStoryStream;
    } catch (e) {
      throw "Error fetching ownStory ${e.toString}";
    }
  }

  Future<void> updateViewer(String storyId) async {
    try {
      final viewedStoriesStream = viewedStoryIds();
      viewedStoriesStream.listen((viewedIds)async {
        if(!viewedIds.contains(storyId) && storyId!=''){
               final viewer = Storyviewer(
          storyId: storyId, viewerId: UserController.instance.user.value.id);
      print("${viewer.storyId} ${viewer.storyId}");
      await FirebaseFirestore.instance
          .collection("StoryViewer")
          .add(viewer.toJson())
          .then((e) => "Added successfully");
        }
      });
 
    } catch (e) {
      throw "Something went wrong $e";
    }
  }

  Future<void> uploadStory(XFile? storyPhoto) async {
    try {
      await storyRef.putFile(File(storyPhoto!.path));
      final storyImage = await storyRef.getDownloadURL();
      final storyId = DateTime.timestamp().millisecondsSinceEpoch.toString();
      final Storymodel storymodel = Storymodel(
          userImage: userController.user.value.photoUrl,
          storyImage: storyImage,
          uploadTime: Timestamp.now(),
          storyId: storyId,
          userId: userController.user.value.id,
          userName: userController.user.value.name);
      await FirebaseFirestore.instance
          .collection("Stories")
          .doc(storyId)
          .set(storymodel.toJson());
      AppLoaders.successSnackBar(title: "success", message: "Story Uploaded");
    } catch (e) {
      AppLoaders.errorSnackBar(
          title: "Error", message: "Could not upload story");
      throw ("Error uploading story");
    }
  }

  Stream<List<String>> viewedStoryIds() {
    try {
      final viewerStoryStream = FirebaseFirestore.instance
          .collection("StoryViewer")
          .where('viewerId', isEqualTo: user)
          .snapshots();

      final viewedStoryIdStream = viewerStoryStream.map((streams) =>
          streams.docs.map((doc) => doc.data()['storyId'] as String).toList());
      return viewedStoryIdStream;
    } catch (e) {
      throw "error ${e.toString()}";
    }
  }

  List<Stream<List<Storymodel>>> getStoryStream() {
    try {
      final storyStream = FirebaseFirestore.instance
          .collection("Stories")
          .where('uploadTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(timeLimit))
          .orderBy('uploadTime')
          .snapshots();

      final storyModelStream = storyStream.map((streams) =>
          streams.docs.map((story) => Storymodel.fromSnapshot(story)).toList());
      final viewedStoryIdStream = viewedStoryIds();
      final viewedStoryModelStream =
          CombineLatestStream.combine2(storyModelStream, viewedStoryIdStream,
              (List<Storymodel> stories, List<String> viewedIds) {
        return stories
            .where((story) => viewedIds.contains(story.storyId))
            .toList();
      });
      final unviewedStoryModelStream =
          CombineLatestStream.combine2(storyModelStream, viewedStoryIdStream,
              (List<Storymodel> stories, List<String> storyIds) {
        return stories
            .where((story) => !storyIds.contains(story.storyId))
            .toList();
      });

      return [unviewedStoryModelStream, viewedStoryModelStream];
    } catch (e) {
      throw "Error getting story Stream";
    }
  }
}
