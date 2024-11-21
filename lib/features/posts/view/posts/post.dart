import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/styles/readmoreless.dart';
import 'package:instagram_clone/features/posts/data/model/postmodel.dart';
import 'package:instagram_clone/features/posts/controllers/commentController.dart';
import 'package:instagram_clone/features/posts/controllers/likecontroller.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/features/posts/view/comments/commentsection.dart';
import 'package:instagram_clone/features/posts/view/posts/like.dart';
import 'package:instagram_clone/features/posts/view/posts/postphoto.dart';
import 'package:instagram_clone/features/posts/view/posts/sharepost.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';

import '../comments/commentbox.dart';

class Post extends StatelessWidget {
  final PostModel post;
  Post({super.key, required this.post});
  final PostImageController postImageController =
      Get.put(PostImageController());
  final ScrollController scrollController = ScrollController();
  final commentBoxController = Get.put(CommentBoxController());

  @override
  Widget build(BuildContext context) {
    final LikeController likeController = Get.put(
        LikeController(postId: post.postId),
        tag: UniqueKey().toString());
    final LikeButtonController likeButtonController = Get.put(
        LikeButtonController(
            likeController: likeController, postId: post.postId),
        tag: UniqueKey().toString());
    final commentController = Get.put(CommentController(postId: post.postId),
        tag: UniqueKey().toString());
    final commentNo =
        commentController.commentStream.map((commets) => commets.length);
    final RxInt likeNumber = 0.obs;
    likeController.likeStream.listen((like) {
      likeNumber.value = like.length;
    });
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: PostUploaderDetails(userId: post.userId,time: post.postTime,),
        ),
        PostPhoto(
          photo: post.postImage,
          likeButtonController: likeButtonController,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceBtwItems),
              child: LikeButton(
                likeButtonController: likeButtonController,
              ),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.comment),
              onPressed: () => _showCommentBottomSheet(context),
            ),
            const SizedBox(
              width: AppSizes.spaceBtwItems,
            ),
            IconButton(
                onPressed: () => _showSharePostBottomSheer(context),
                icon: const Icon(FontAwesomeIcons.paperPlane)),
            const Spacer(),
            PostSliderDots(
              postNumber: 1,
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceBtwItems),
              child: Icon(FontAwesomeIcons.bookmark),
            )
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.spaceBtwItems),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => likeNumber.value == 0
                  ? const Text("Likes")
                  : Text('Liked by ${likeNumber.value} others')),
              ReadMoreLess(data: "  ${post.caption}"),
              StreamBuilder(
                  stream: commentNo,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == 0) {
                      return const Text("Be the first to comment");
                    }
                    if (snapshot.hasError) {
                      return const Text("Error in commentStream");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    return GestureDetector(
                        onTap: () => _showCommentBottomSheet(context),
                        child: Text("view all ${snapshot.data} comments"));
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: GestureDetector(
            onTap: () {
              _showCommentBottomSheet(context);
            },
            child: CommentBox(
              postId: post.postId,
            ),
          ),
        )
      ]),
    );
  }

  _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        elevation: AppSizes.cardElevation,
        scrollControlDisabledMaxHeightRatio: 0.5,
        context: context,
        builder: (context) {
          return CommentSection(
            post: post,
          );
        });
  }
}



_showSharePostBottomSheer(BuildContext context) {
  showSharePost(context);
}

class PostSliderDots extends StatelessWidget {
  PostSliderDots({super.key, required this.postNumber});
  final num postNumber;
  final ScrollController scrollController = ScrollController();
  final PostImageController postImageController =
      Get.put(PostImageController());

  @override
  Widget build(BuildContext context) {
    return postNumber.toInt() == 1
        ? const SizedBox()
        : SizedBox(
            width: 80,
            height: 50,
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Scroll to the selected index
                if (scrollController.hasClients) {
                  double itemSize = AppSizes.sm + 4; // Size plus padding
                  double viewportWidth =
                      scrollController.position.viewportDimension;
                  double centerOffset = viewportWidth / 2 - itemSize / 2;
                  double scrollOffset =
                      (postImageController.selectedIndex.value * itemSize) -
                          centerOffset;

                  // Ensure the offset is within bounds
                  double maxScrollExtent =
                      scrollController.position.maxScrollExtent;
                  double minScrollExtent =
                      scrollController.position.minScrollExtent;
                  if (scrollOffset < minScrollExtent) {
                    scrollOffset = minScrollExtent;
                  } else if (scrollOffset > maxScrollExtent) {
                    scrollOffset = maxScrollExtent;
                  }
                  scrollController.animateTo(
                    scrollOffset,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              });
              return ListView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                children: List.generate(postNumber.toInt(), (index) {
                  final bool isSelected =
                      postImageController.selectedIndex.value == index;
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: isSelected ? AppSizes.sm : AppSizes.xs,
                      width: isSelected ? AppSizes.sm : AppSizes.xs,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected ? Colors.blue : AppColors.darkerGrey),
                    ),
                  );
                }),
              );
            }),
          );
  }
}

class PostImageController extends GetxController {
  RxInt selectedIndex = 0.obs;
  void setValue(value) {
    selectedIndex.value = value;
  }
}
