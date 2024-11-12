import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/postmodel.dart';
import 'package:instagram_clone/data/repositories/followrepository.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/postcontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/reelcontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';
import 'package:instagram_clone/features/personalization/screens/ReelScreen/reelscreen.dart';
import 'package:instagram_clone/features/personalization/screens/ReelScreen/reelvideocontroller.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/profileimagewidget.dart';
import 'package:instagram_clone/features/personalization/screens/ProfileScreen/editprofile.dart';
import 'package:instagram_clone/features/personalization/screens/ProfileScreen/settings.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/enums.dart';
import 'package:instagram_clone/utils/constants/icons.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/models/followmodel.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppHelperFunctions.isDarkMode(context);
    final color = isDark ? AppColors.white : AppColors.dark;
    List tabIcons = [
      Icon(Icons.article),
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
                    return Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  if (!snapshot.hasData) {
                    return Text("No data");
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
                      SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      Text(
                        userController.user.value.bio,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
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
                      SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      TabBar(
                          tabs: List.generate(
                              2,
                              (index) => Tab(
                                    child: tabIcons[index],
                                  ))),
                      Container(
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
    return Container(
        height: 400,
        width: 200,
        child: GridView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
    return Container(
        height: 400,
        width: 200,
        child: GridView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: reelcontroller.ownReels.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
                      return Text("no thumbNail");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 80,
                        width: 60,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text("Error");
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
