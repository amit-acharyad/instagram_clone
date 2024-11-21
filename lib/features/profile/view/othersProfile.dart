import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/shimmer.dart';
import 'package:instagram_clone/features/posts/data/repository/postrepository.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/reel/controller/reelcontroller.dart';
import 'package:instagram_clone/features/profile/data/model/usermodel.dart';
import 'package:instagram_clone/features/message/view/widgets/chatscreen.dart';

import '../data/model/followmodel.dart';
import '../data/repository/followrepository.dart';
import '../../../localizations/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/icons.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../posts/view/posts/postuploader.dart';
import '../../reel/view/reelscreen.dart';
import '../../reel/controller/reelvideocontroller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final Followrepository followrepository = Get.put(
        Followrepository(currentUserId: userModel.id),
        tag: UniqueKey().toString());
    final Postrepository postrepository = Get.put(Postrepository());

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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Get.isDarkMode
                  ? Colors.white
                  : Colors.black, // Adapts color based on theme
            ),
            onPressed: () {
              Get.back(); // Uses GetX navigation for going back
            },
          ),
          title: TextButton(
            onPressed: () {},
            child: SizedBox(
              child: Text(
                userModel.name,
                style: Theme.of(context).textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
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
                          followerModel.userId == userModel.id)
                      .toList();
                  final followerIds = followerModels
                      .map((follower) => follower.followerId)
                      .toList();
                  final followingModels = follow
                      .where((follower) => follower.followerId == userModel.id)
                      .toList();
                  final followingIds = followingModels
                      .map((following) => following.userId)
                      .toList();
                  final bool following = followerIds.contains(
                      AuthenticationRepository.instance.authUser!.uid);

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
                                  image: userModel.photoUrl,
                                )),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FutureBuilder(
                                      future: postrepository
                                          .fetchPostofUser(userModel.id),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const AppShimmerEffect(
                                            width: 40,
                                            height: 20,
                                            radius: 1,
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data!.length.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                            "error",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          );
                                        }
                                        return Text(
                                          '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        );
                                      }),
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
                        userModel.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      Text(
                        userModel.bio,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwItems,
                      ),
                      Row(
                        children: [
                          !(userModel.id ==
                                  AuthenticationRepository
                                      .instance.authUser!.uid)
                              ? following
                                  ? SizedBox(
                                      width:
                                          MediaQuery.sizeOf(context).width / 2,
                                      child: OutlinedButton(
                                          onPressed: () async {
                                            await followrepository.unfollow();
                                          },
                                          child: Text(
                                            "Following",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          )),
                                    )
                                  : SizedBox(
                                      width:
                                          MediaQuery.sizeOf(context).width / 2,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await followrepository.follow();
                                          },
                                          child: Text(
                                            "Follow",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          )),
                                    )
                              : const SizedBox(),
                          const SizedBox(
                            width: AppSizes.spaceBtwItems,
                          ),
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () =>
                                    Get.to(ChatScreen(user: userModel)),
                                child: const Text("Message")),
                          ),
                        ],
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
                          PostTabBar(userId: userModel.id),
                          ReelTabBar(
                            userId: userModel.id,
                          )
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
  PostTabBar({super.key, required this.userId});
  String userId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Postrepository.instance.fetchPostofUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(
              "error",
              style: Theme.of(context).textTheme.headlineSmall,
            );
          }
          if (!snapshot.hasData) {
            return const Text("No Posts");
          }
          return SizedBox(
              height: 400,
              width: 200,
              child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    final post = snapshot.data?[index];
                    return Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(post!.postImage))),
                    );
                  }));
        });
  }
}

class ReelTabBar extends StatelessWidget {
  ReelTabBar({super.key, required this.userId});
  String userId;
  @override
  Widget build(BuildContext context) {
    print("reels of user $userId");
    return FutureBuilder(
        future: Reelcontroller.instance.fetchReelsOfUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("NO reels Available");
          }
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data;
          print("data of reels is${data!.first.uploaderName}");
          return SizedBox(
              height: 400,
              width: 200,
              child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    final reel = data[index];
                    final ReelVideoController reelVideoController = Get.put(
                        ReelVideoController(reelUrl: Uri.parse(reel.reelUrl)),
                        tag: UniqueKey().toString());
                    print(
                        "reels of $userId} are ${reel.uploaderName} ${reel.uploaderId}");
                    return FutureBuilder(
                        future: Reelcontroller.instance
                            .generateThumbnail(reel.reelUrl),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("no thumbNail");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                              child: SizedBox(height:300,width:300, child: Image.memory(snapshot.data!)));
                        });
                  }));
        });
  }
}
