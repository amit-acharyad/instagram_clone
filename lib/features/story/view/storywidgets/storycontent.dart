import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../../data/models/storymodel.dart';

class Storycontent extends StatelessWidget {
  const Storycontent({super.key, required this.story});
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
  const StoryUploader({super.key, required this.story});
  final Storymodel story;
  @override
  Widget build(BuildContext context) {
   

    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
      child: SizedBox(
        height: AppHelperFunctions.screenHeight(context) * 0.05,
        child:PostUploaderDetails(userId: story.userId, time: story.uploadTime)
      ),
    );
  }
}
