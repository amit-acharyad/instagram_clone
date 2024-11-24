import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/profile/data/repository/userrepository.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/helpers/helper_functions.dart';
import '../../posts/view/posts/postuploader.dart';
import '../controller/reelvideocontroller.dart';

class SingleReelScreen extends StatelessWidget {
  const SingleReelScreen(
      {super.key,
      required this.reelVideoController,
      required this.uploaderId,
      required this.uploaderName});
  final ReelVideoController reelVideoController;
  final String uploaderName;
  final String uploaderId;

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
                    child:
                        VideoPlayer(reelVideoController.videoPlayerController),
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
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outline)),
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
                  FutureBuilder(
                      future: UserRepository.instance
                          .fetchUserWithGivenId(uploaderId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return CircularProgressIndicator.adaptive();
                        }

                        final user = snapshot.data;
                        return PostUploader(size: 24, image: user!.photoUrl);
                      }),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(uploaderName),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
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
