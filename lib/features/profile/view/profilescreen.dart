import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/posts/data/model/postmodel.dart';
import 'package:instagram_clone/features/posts/controllers/postcontroller.dart';
import 'package:instagram_clone/features/reel/controller/reelcontroller.dart';
import 'package:instagram_clone/features/profile/controller/usercontroller.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/features/reel/view/reelscreen.dart';
import 'package:instagram_clone/features/reel/controller/reelvideocontroller.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/features/profile/view/editprofile.dart';
import 'package:instagram_clone/features/profile/view/settings.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/icons.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../data/model/followmodel.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppHelperFunctions.isDarkMode(context);
    final color = isDark ? AppColors.white : AppColors.dark;
    List tabIcons = [
      const Icon(Icons.article),
      AppIcons.reelIcon(color),
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: TextButton(
              onPressed: () {},
              child: SizedBox(
                child: Text(
                  userController.user.value.userName,
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add_box_outlined,
                  color: color,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Get.to(SettingsScreen());
                  },
                  icon: Icon(
                    Icons.list,
                    color: color,
                  ))
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Follow").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  if (!snapshot.hasData) {
                    return const Text("No data");
                  }
                  final follow = snapshot.data!.docs
                      .map((snapshot) => FollowModel.fromSnapshot(snapshot))
                      .toList();
                  final followerModels = follow
                      .where((followerModel) =>
                          followerModel.userId == userController.user.value.id)
                      .toList();
                  final followerIds = followerModels
                      .map((follower) => follower.followerId)
                      .toList();

                  final followingModels = follow
                      .where((follower) =>
                          follower.followerId == userController.user.value.id)
                      .toList();
                  final followingIds = followingModels
                      .map((following) => following.userId)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: PostUploader(
                                  size: 20,
                                  image: userController.user.value.photoUrl,
                                )),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    Postcontroller.instance.ownPosts.length
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).posts,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    followerIds.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).followers,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    followingIds.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).following,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        userController.user.value.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      Text(
                        userController.user.value.bio,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: OutlinedButton(
                            onPressed: () => Get.to(EditProfile()),
                            child: Text(
                              AppLocalizations.of(context).editProfile,
                              style: Theme.of(context).textTheme.titleSmall,
                            )),
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      TabBar(
                          tabs: List.generate(
                              2,
                              (index) => Tab(
                                    child: tabIcons[index],
                                  ))),
                      SizedBox(
                        height: 500,
                        width: 400,
                        child: TabBarView(children: [
                          PostTabBar(posts: Postcontroller.instance.ownPosts),
                          ReelTabBar()
                        ]),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class PostTabBar extends StatelessWidget {
  PostTabBar({super.key, required this.posts});
  List<PostModel> posts;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        width: 200,
        child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              final post = posts[index];
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(post.postImage))),
              );
            }));
  }
}

class ReelTabBar extends StatelessWidget {
  ReelTabBar({super.key});
  final Reelcontroller reelcontroller = Reelcontroller.instance;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        width: 200,
        child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: reelcontroller.ownReels.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              print("no of reels is ${reelcontroller.ownReels.length}");
              final reel = reelcontroller.ownReels[index];
              final ReelVideoController reelVideoController = Get.put(
                  ReelVideoController(reelUrl: Uri.parse(reel.reelUrl)),
                  tag: UniqueKey().toString());
              return FutureBuilder(
                  future: reelcontroller.generateThumbnail(reel.reelUrl),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("no thumbNail");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 80,
                        width: 60,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text("Error");
                    }
                    return InkWell(
                        onTap: () => Get.to(SingleReelScreen(
                            reelVideoController: reelVideoController,
                            uploaderName: reel.uploaderName)),
                        child: Image.memory(snapshot.data!));
                  });
            }));
  }
}
