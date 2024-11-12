import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/myappbar.dart';
import 'package:instagram_clone/data/models/notificationModel.dart';
import 'package:instagram_clone/data/repositories/postrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/data/models/usermodel.dart';
import 'package:instagram_clone/features/personalization/data/repositories/userrepository.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/post.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/profileimagewidget.dart';
import 'package:instagram_clone/features/personalization/screens/ProfileScreen/othersProfile.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/enums.dart';

import '../../../../common/styles/dateTimeformatter.dart';
import '../../../../data/models/postmodel.dart';

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
            return Text("No data");
          }
          if (!snapshot.hasData) {
            return const Text("No Data");
          }
          if (snapshot.hasError) {
            return Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Text("Loading");
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
                Spacer(),
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
                        return CircularProgressIndicator();
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
                  appBar: MyAppBar(showBackArrow: true),
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
