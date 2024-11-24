import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../reel/controller/reelcontroller.dart';
import '../../../../reel/controller/reelvideocontroller.dart';
import '../../../../reel/view/singlereelscreen.dart';

class ReelTabBar extends StatelessWidget {
  ReelTabBar({super.key});
  final Reelcontroller reelcontroller = Reelcontroller.instance;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reelcontroller.ownReels.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          final reel = reelcontroller.ownReels[index];
          final ReelVideoController reelVideoController = Get.put(
              ReelVideoController(reelUrl: Uri.parse(reel.reelUrl)),
              tag: UniqueKey().toString());
          return FutureBuilder(
              future: reelcontroller.generateThumbnail(reel.reelUrl),
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
                        uploaderId: reel.uploaderId,
                        reelVideoController: reelVideoController,
                        uploaderName: reel.uploaderName)),
                    child: Image.memory(snapshot.data!));
              });
        });
  }
}
