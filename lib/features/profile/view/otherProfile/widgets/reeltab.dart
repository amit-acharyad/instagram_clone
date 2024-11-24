import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../reel/controller/reelcontroller.dart';
import '../../../../reel/controller/reelvideocontroller.dart';
import '../../../../reel/view/singlereelscreen.dart';

class OthersReelTabBar extends StatelessWidget {
  OthersReelTabBar({super.key, required this.userId});
  String userId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Reelcontroller.instance.fetchReelsOfUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("NO reels Available");
          }
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data;
          return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                final reel = data[index];
                final ReelVideoController reelVideoController = Get.put(
                    ReelVideoController(reelUrl: Uri.parse(reel.reelUrl)),
                    tag: UniqueKey().toString());

                return FutureBuilder(
                    future:
                        Reelcontroller.instance.generateThumbnail(reel.reelUrl),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 80,
                          width: 60,
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      return InkWell(
                          onTap: () => Get.to(SingleReelScreen(
                              reelVideoController: reelVideoController,
                              uploaderId: reel.uploaderId,
                              uploaderName: reel.uploaderName)),
                          child: SizedBox(
                              height: 300,
                              width: 300,
                              child: Image.memory(snapshot.data!)));
                    });
              });
        });
  }
}
