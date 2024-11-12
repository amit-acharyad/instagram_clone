import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/myappbar.dart';
import 'package:instagram_clone/features/personalization/controllers/storycontroller.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/comments/singlecomment.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/profileimagewidget.dart';
import 'package:instagram_clone/features/personalization/screens/notification/notification_tile.dart';
import 'package:instagram_clone/utils/constants/enums.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../../../../../../data/models/storymodel.dart';

class Storycontent extends StatelessWidget {
  Storycontent({super.key, required this.story});
  final Storymodel story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoryUploader(story: story),
              Container(
                  height: AppHelperFunctions.screenHeight(context) * 0.9,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: CachedNetworkImageProvider(story.storyImage)))),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryUploader extends StatelessWidget {
  StoryUploader({super.key, required this.story});
  final Storymodel story;
  @override
  Widget build(BuildContext context) {
   

    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
      child: Container(
        height: AppHelperFunctions.screenHeight(context) * 0.05,
        child:PostUploaderDetails(userId: story.userId, time: story.uploadTime)
      ),
    );
  }
}
