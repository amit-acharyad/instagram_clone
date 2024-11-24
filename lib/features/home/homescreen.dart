import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/posts/controllers/postcontroller.dart';
import 'package:instagram_clone/features/story/controller/storycontroller.dart';
import 'package:instagram_clone/features/posts/view/posts/post.dart';
import 'package:instagram_clone/features/posts/view/posts/postShimmer.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../authentication/data/authenticationrepository.dart';
import '../videocall/controller/videoCallChecker.dart';
import '../videocall/view/incomingcallScreen.dart';
import 'widgets/homeappbar.dart';
import '../story/view/stories.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final Storycontroller storycontroller = Get.put(Storycontroller());
  final Postcontroller postcontroller = Get.put(Postcontroller());

  @override
  Widget build(BuildContext context) {
   
    print("post controller posts no is ${postcontroller.posts.length}");
    return Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Stories Section
            // Obx(() {
            //   final video = webRTCVideoController.videoCall.value;
            //   final callEnded = webRTCVideoController.callEnded.value;
            //   final user = AuthenticationRepository.instance.authUser!.uid;
            //   print("call end value is $callEnded");
            //   if (video.initiatorId != user &&
            //       video.status == "initiated" &&
            //       (!callEnded)) {
            //     return InkWell(
            //       onTap: () => Get.to(IncomingCallScreen(videoCall: video)),
            //       child: Container(
            //         height: 40,
            //         width: AppHelperFunctions.screenWidth(context),
            //         decoration: const BoxDecoration(color: Colors.green),
            //         child: const Center(child: Text("Incoming Call")),
            //       ),
            //     );
            //   } else {
            //     print("returned sized box");
            //     return const SizedBox();
            //   }
            // }),
            Obx(
            () => VideoCallChecker.currentCall.value.status == 'initiated'
                ? GestureDetector(
                    onTap: () {
                      print(
                          "Going to join room ${VideoCallChecker.currentCall.value.roomId}");
                      Get.to(IncomingCallScreen());
                      // Get.to(WebRTCVideoCallScreen(
                      //   receiverId: "1",
                      //   roomId: VideoCallChecker.currentCall.value.roomId,
                      // ));
                    },
                    child: ColoredBox(
                      color: Colors.green,
                      child:  SizedBox(
                        height: 40,
                        width: AppHelperFunctions.screenWidth(context),
                        child: Center(child: Text('Incoming Call')),
                      ),
                    ),
                  )
                : SizedBox(),
          ),

            Stories(),
            //Post Section
            const SizedBox(
              height: 5,
            ),
            Obx(() {
              if (postcontroller.isLoadingPosts.value) {
                return const PostShimmer();
              }
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postcontroller.posts.length,
                  itemBuilder: (_, index) {
                    final post = postcontroller.posts[index];

                    return Post(
                      post: post,
                    );
                  });
            })
            //Suggested Section
          ],
        ),
      ),
    );
  }
}
