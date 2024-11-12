import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/personalization/controllers/postcontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/reelcontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/storycontroller.dart';
import 'package:instagram_clone/features/personalization/screens/Addcontentscreen/addPost.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/icons.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

class AddContentScreen extends StatelessWidget {
  AddContentScreen({super.key});
  final Postcontroller postcontroller = Get.put(Postcontroller());
  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final color = isDark ? AppColors.white : AppColors.dark;
    final Reelcontroller reelcontroller = Get.put(Reelcontroller());
    final Storycontroller storycontroller = Get.put(Storycontroller());
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.appBarHeight, horizontal: AppSizes.appBarHeight),
        child: Center(
          child: Container(
            height: 300,
            decoration: BoxDecoration(border: Border.all()),
            width: double.maxFinite,
            child: Column(
              children: [
                ListTile(
                  leading: Text(
                    "Post",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  title: const Icon(Icons.list),
                  onTap: () async {
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    print(image);
                    final images = [image];
                    postcontroller.image.assignAll(images);
                    Get.to(const AddPost());
                  },
                ),
                ListTile(
                  leading: Text("Story",
                      style: Theme.of(context).textTheme.labelLarge),
                  title: const Icon(Icons.circle),
                  onTap: () async {
                    await storycontroller.uploadStory();
                  },
                ),
                ListTile(
                  leading: Text("Reel",
                      style: Theme.of(context).textTheme.labelLarge),
                  title: AppIcons.reelIcon(color),
                  onTap: () async {
                    await reelcontroller.uploadReels();
                  },
                ),
                Obx(() {
                  if (reelcontroller.isUploadingReel.value ||
                      postcontroller.isUploadingPost.value ||
                      storycontroller.isUploadingStory.value) {
                    return const Center(
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                })
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class UploadMenu extends StatelessWidget {
  const UploadMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final color = isDark ? AppColors.white : AppColors.dark;
    final Reelcontroller reelcontroller = Get.put(Reelcontroller());
    final Storycontroller storycontroller = Get.put(Storycontroller());
    final Postcontroller postcontroller = Get.put(Postcontroller());

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              UploadOption(
                icon: FontAwesomeIcons.plus,
                label: 'Post',
                onTap: () async {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  print(image);
                  final images = [image];
                  postcontroller.image.assignAll(images);
                  Get.to(const AddPost());
                },
                isLoading: postcontroller
                    .isUploadingPost, // Pass isLoading to UploadOption
              ),
              UploadOption(
                icon: FontAwesomeIcons.circle,
                label: 'Story',
                onTap: () async {
                  print("TApped");
                  await storycontroller.uploadStory();
                },
                isLoading: storycontroller.isUploadingStory,
              ),
              UploadOption(
                icon: FontAwesomeIcons.film,
                label: 'Reel',
                onTap: () async {
                  await reelcontroller.uploadReels();
                },
                isLoading: reelcontroller.isUploadingReel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final RxBool isLoading; // Add isLoading bool

  const UploadOption({super.key, 
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkerGrey,
                ),
                child: Icon(
                  icon,
                  size: 32.0,
                ),
              ),
              Obx(() {
                if (isLoading
                    .value) {
                  // Show circular progress indicator if isLoading is true
                  return const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue, // Customize progress indicator color
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              })
            ],
          ),
          const SizedBox(height: 8.0),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
