import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/repositories/commentrepository.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/utils/popups/loaders.dart';

import '../../../data/models/commentModel.dart';

class CommentController extends GetxController {
 static CommentController get instance => Get.find();
  final CommentRepository commentRepository = Get.put(CommentRepository());
  
  final String postId;
  CommentController({required this.postId});
  final UserController userController = Get.put(UserController());
  @override
  void onInit() {
    super.onInit();
  
  }
   Stream<List<CommentModel>> get commentStream=>commentRepository.fetchComments(postId);

 

  Future<void> addComment(String comment) async {
    try {
      final CommentModel commentModel = CommentModel(
          postId: postId,
          userId: userController.user.value.id,
          time: Timestamp.fromDate(DateTime.now()),
          comment: comment,
          commentId: DateTime.now().millisecondsSinceEpoch.toString());
      await commentRepository.uploadComment(commentModel);
    } catch (e) {
      AppLoaders.errorSnackBar(
          title: "Error", message: "Could not add Commetn");
      throw 'COuld not add comment';
    }
  }
}
