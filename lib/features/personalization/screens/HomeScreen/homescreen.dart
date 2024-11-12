import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/personalization/controllers/postcontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/storycontroller.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/post.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postShimmer.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/story/storiesshimmer.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/story/storycontent.dart';
import 'package:instagram_clone/features/personalization/screens/message/incomingCallScreen.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../../../../data/models/videocallModel.dart';
import '../../../authentication/data/authenticationrepository.dart';
import '../../controllers/webRtcVideoController.dart';
import '../navigationscreen.dart';
import 'widgets/homeappbar.dart';
import 'widgets/story/stories.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final Storycontroller storycontroller = Get.put(Storycontroller());
  final Postcontroller postcontroller = Get.put(Postcontroller());

  @override
  Widget build(BuildContext context) {
    final WebRTCVideoController webRTCVideoController =
        Get.put(WebRTCVideoController());
    print("post controller posts no is ${postcontroller.posts.length}");
    return Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Stories Section
            Obx(() {
              final video = webRTCVideoController.videoCall.value;
              final callEnded = webRTCVideoController.callEnded.value;
              final user = AuthenticationRepository.instance.authUser!.uid;
              print("call end value is $callEnded");
              if (video.initiatorId != user &&
                  video.status == status['0'] &&
                  (!callEnded)) {
                return InkWell(
                  onTap: () => Get.to(IncomingCallScreen(videoCall: video)),
                  child: Container(
                    height: 40,
                    width: AppHelperFunctions.screenWidth(context),
                    decoration: const BoxDecoration(color: Colors.green),
                    child: const Center(child: Text("Incoming Call")),
                  ),
                );
              } else {
                print("returned sized box");
                return SizedBox();
              }
            }),

            Stories(),
            //Post Section
            SizedBox(
              height: 5,
            ),
            Obx(() {
              if (postcontroller.isLoadingPosts.value) {
                return PostShimmer();
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
