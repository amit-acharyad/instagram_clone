import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/story/controller/storycontroller.dart';
import 'package:instagram_clone/features/profile/controller/usercontroller.dart';
import 'package:instagram_clone/features/home/widgets/profileimagewidget.dart';
import 'package:instagram_clone/features/story/view/storywidgets/storiesshimmer.dart';
import 'package:instagram_clone/utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';

class Stories extends StatelessWidget {
  Stories({
    super.key,
  });
  final Storycontroller storycontroller = Get.put(Storycontroller());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: [
                Stack(
                  children: [
                    Obx(
                      ()=> Container(
                                  width: 75, // Adjust width as needed
                                  height: 75, // Adjust height as needed
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        UserController.instance.user.value.photoUrl,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    Positioned(
            bottom: -8,
            right: -8,
            child: IconButton(
              onPressed: () async {
                storycontroller.uploadStory();
              },
              icon: const Icon(
                Icons.add_circle,
                color: Colors.blue,
                size: 24,
              ),
            ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Adds space between the image and text
                const Padding(padding: EdgeInsets.only(left: 15), child: Text("Your Story")),
              ],
            ),
          ),

          
          const SizedBox(
            width: AppSizes.spaceBtwItems,
          ),
          ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return StreamBuilder(
                    stream: storycontroller.storyStreams[index],
                    builder: (context, snapshot) {
                      int i = index;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const StoriesShimmer();
                      }
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      final data = snapshot.data;
                      return SizedBox(
                        height: 100,
                        child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              final story = data[index];
                              return Column(
                                children: [
                                  ProfileImageWidget(
                                    yourStory: false,
                                    story: story,
                                    size: 85,
                                    storyStatus: i == 0
                                        ? StoryStatus.notseen
                                        : StoryStatus.seen,
                                  ),
                                  Text(story.userName)
                                ],
                              );
                            }),
                            separatorBuilder: (_, __) => const SizedBox(
                                  width: AppSizes.spaceBtwItems,
                                ),
                            itemCount: data!.length),
                      );
                    });
              })
        ],
      ),
    );
  }
}
