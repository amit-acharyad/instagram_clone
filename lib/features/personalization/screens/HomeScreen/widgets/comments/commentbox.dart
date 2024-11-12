import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/personalization/controllers/commentController.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/data/models/usermodel.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';


class CommentBox extends StatelessWidget {
  CommentBox({
    super.key,
    required this.postId,
  });
  final String postId;
  final CommentBoxController commentBoxController =
      Get.put(CommentBoxController(), tag: UniqueKey().toString());
  final UserModel user = UserController.instance.user.value;
  @override
  Widget build(BuildContext context) {
    final CommentController commentController =
        Get.put(CommentController(postId: postId), tag: UniqueKey().toString());

    return SizedBox(
      child: Obx(
        () => TextFormField(
          onChanged: (value) =>
              commentBoxController.updateCommentBoxStatus(value.isEmpty),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: PostUploader(
                size: 16,
                image: user.photoUrl,
              ),
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: 'add a comment',
            suffixIcon: !commentBoxController.commentSend.value
                ? IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      commentController.addComment(commentBoxController
                          .commentTextController.text
                          .trim());
                      commentBoxController.commentTextController.clear();
                    },
                    color: Colors.blue,
                  )
                : null,
          ),
          controller: commentBoxController.commentTextController,
        ),
      ),
    );
  }
}

class CommentBoxController extends GetxController {
  final commentTextController = TextEditingController();

  RxBool commentSend = true.obs;
  void updateCommentBoxStatus(status) {
    commentSend.value = status;
  }
}
