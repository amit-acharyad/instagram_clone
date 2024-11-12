import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/likecontroller.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.likeButtonController,
  });
  final LikeButtonController likeButtonController;
  @override
  Widget build(context) {
    return Obx(
      () => IconButton(
        onPressed: () => likeButtonController.updateLikeStatus(),
        icon: likeButtonController.liked.value
            ? const Icon(
                FontAwesomeIcons.solidHeart,
                color: Colors.red,
              )
            : const Icon(FontAwesomeIcons.heart),
      ),
    );
  }
}

class LikeButtonController extends GetxController {
  static LikeButtonController get instance => Get.find();
  LikeButtonController({required this.likeController, required this.postId});
  final LikeController likeController;
  RxBool liked = false.obs;
  final String postId;
  final currentuser = AuthenticationRepository.instance.authUser!.uid;
  @override
  void onInit() {
    super.onInit();

    final like =
        likeController.likeStream.map((userIds) => userIds.contains(currentuser));

    like.listen((like) {
      liked.value = like;
    });
  }

  void updateLikeStatus() async {
    liked.value = !liked.value;

    if (liked.value) {
      await likeController.likePost(postId);
    } else {
      await likeController.unlikePost(postId);
    }
  }
}
