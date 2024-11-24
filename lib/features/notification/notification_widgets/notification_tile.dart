import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/myappbar.dart';
import 'package:instagram_clone/features/notification/data/notificationModel.dart';
import 'package:instagram_clone/features/posts/data/repository/postrepository.dart';
import 'package:instagram_clone/features/profile/data/model/usermodel.dart';
import 'package:instagram_clone/features/profile/data/repository/userrepository.dart';
import 'package:instagram_clone/features/posts/view/posts/post.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/features/profile/view/otherProfile/othersProfile.dart';
import 'package:instagram_clone/utils/constants/colors.dart';

import '../../../common/styles/dateTimeformatter.dart';
import '../../posts/data/model/postmodel.dart';

class NotificationTile extends StatelessWidget {
  NotificationTile({super.key, required this.notificationModel});
  final NotificationModel? notificationModel;
  final UserRepository userRepository = Get.put(UserRepository());
  final Postrepository postRepository = Get.put(Postrepository());
  PostModel post = PostModel.empty();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: UserModel.empty(),
        future: userRepository.fetchUserWithGivenId(notificationModel!.userId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Text("No data");
          }
          if (!snapshot.hasData) {
            return const Text("No Data");
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Text("Loading");
          }
          return ListTile(
            leading: PostUploader(size: 10, image: snapshot.data!.photoUrl),
            title: Text(
              snapshot.data!.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Row(
              children: [
                Flexible(
                    flex: 8,
                    child: Text(
                      notificationModel!.type == "follow"
                          ? 'started following you'
                          : 'commented on your post',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.darkerGrey),
                    )),
                const Spacer(),
                Flexible(
                    flex: 2,
                    child: Text(
                      formatTimeDifference(notificationModel!.time.toDate()),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.darkerGrey),
                    )),
              ],
            ),
            trailing: notificationModel!.type == "comment"
                ? FutureBuilder(
                    future: postRepository.fetchPost(notificationModel!.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData ||
                          snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      post = snapshot.data!;
                      return Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: CachedNetworkImageProvider(
                                    snapshot.data!.postImage))),
                      );
                    })
                : SizedBox(
                    height: 70,
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () =>
                            Get.to(Profile(userModel: snapshot.data!)),
                        child: Text(
                          'View Profile',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ))),
            onTap: () {
              if (notificationModel!.type == "comment") {
                Get.to(Scaffold(
                  appBar: const MyAppBar(showBackArrow: true),
                  body: SafeArea(
                    child: Post(
                      post: post,
                    ),
                  ),
                ));
              } else {
                Get.to(Profile(userModel: snapshot.data!));
              }
            },
          );
        });
  }

  
}
