import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/storymodel.dart';
import 'package:instagram_clone/features/personalization/controllers/storycontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/story/storycontent.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/enums.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ProfileImageWidget extends StatefulWidget {
  ProfileImageWidget(
      {required this.size,
      required this.storyStatus,
      required this.story,
      required this.yourStory});

  StoryStatus storyStatus;
  double size;
  final Storymodel? story;
  final bool yourStory;

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  void updateStoryStatus() {
    if (widget.storyStatus == StoryStatus.notseen) {
      setState(() {
        widget.storyStatus = StoryStatus.seen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final color = !isDark ? AppColors.white : AppColors.dark;
    final Storycontroller storycontroller = Get.put(Storycontroller());

    return InkWell(
      onTap: () async {
        await storycontroller.updateViewer(widget.story!.storyId);
        updateStoryStatus();
        Get.to(Storycontent(story: widget.story!));
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: getBoxDecoration(widget.storyStatus),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Padding(
                padding: EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppSizes.storiesRadius),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              widget.story!.userImage))),
                )),
          ),
        ),
      ),
    );
  }

  BoxDecoration getBoxDecoration(StoryStatus _storyStatus) {
    switch (_storyStatus) {
      case (StoryStatus.expired):
        return const BoxDecoration(
            shape: BoxShape.circle, color: Colors.transparent);
      case (StoryStatus.notseen):
        return const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFF9CE34),
              Color(0xFFEE2A7B),
              Color(0xFF6228D7),
              // Color(0xFFFEDA75),
              // Color(0xFFFA7E1E),
              // Color(0xFFD62976),
              // Color(0xFF962FBF),
              // Color(0xFF4F5BD5),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        );
      case (StoryStatus.seen):
        return const BoxDecoration(shape: BoxShape.circle, color: Colors.grey);
    }
  }
}
