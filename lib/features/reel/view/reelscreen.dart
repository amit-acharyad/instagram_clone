import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/reel/controller/reelcontroller.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/features/reel/controller/reelvideocontroller.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';
import 'package:video_player/video_player.dart';

class ReelScreen extends StatelessWidget {
  ReelScreen({super.key});

  final Reelcontroller reelcontroller = Get.put(Reelcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => PageView.builder(
            itemCount: reelcontroller.reels.length,
            // itemCount: 4,
            scrollDirection: Axis.vertical,
            // onPageChanged: (index) {
            //   final reel = reelcontroller.reels[index];
            // },
            itemBuilder: (context, index) {
              final reel = reelcontroller.reels[index];
              ReelVideoController reelVideoController = Get.put(
                  ReelVideoController(reelUrl: Uri.parse(reel.reelUrl)),
                  tag: UniqueKey().toString());
              return SingleReelScreen(
                  reelVideoController: reelVideoController,
                  uploaderName: reel.uploaderName);
            }),
      ),
    );
  }
}

class SingleReelScreen extends StatelessWidget {
  const SingleReelScreen(
      {super.key,
      required this.reelVideoController,
      required this.uploaderName});
  final ReelVideoController reelVideoController;
  final String uploaderName;

  @override
  Widget build(BuildContext context) {
    reelVideoController.initializeReel();
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => reelVideoController.isInitialized.value
              ? InkWell(
                  onTap: () {
                    reelVideoController.playpause();
                  },
                  child: SizedBox(
                    height: AppHelperFunctions.screenHeight(context),
                    width: AppHelperFunctions.screenWidth(context),
                    child: VideoPlayer(reelVideoController.videoPlayerController),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
          Positioned(
              right: 0,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
                  const Text("Likes"),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.comment),
                  ),
                  const Text("112"),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share))
                ],
              )),
          Positioned(
              bottom: 20,
              left: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PostUploader(size: 20, image: ''),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(uploaderName),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      height: 35,
                      width: 100,
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "Follow",
                            style: Theme.of(context).textTheme.bodySmall,
                          )))
                ],
              ))
        ],
      ),
    );
  }
}
