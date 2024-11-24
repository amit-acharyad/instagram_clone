import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/reel/controller/reelcontroller.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/features/reel/controller/reelvideocontroller.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';
import 'package:video_player/video_player.dart';

import 'singlereelscreen.dart';

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
                  uploaderId: reel.uploaderId,
                  uploaderName: reel.uploaderName);
            }),
      ),
    );
  }
}

