import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_clone/data/models/videocallModel.dart';
import 'package:instagram_clone/features/authentication/controllers/logincontroller.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/authentication/presentation/screens/loginscreen.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/webRtcVideoController.dart';
import 'package:instagram_clone/features/personalization/data/repositories/userrepository.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/profileimagewidget.dart';
import 'package:instagram_clone/features/personalization/screens/SearchScreen/searchScreen2.dart';
import 'package:instagram_clone/features/personalization/screens/message/incomingCallScreen.dart';
import 'package:instagram_clone/features/personalization/screens/message/videocall.dart';
import 'package:instagram_clone/features/personalization/screens/message/webrtcVideoScreen.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/enums.dart';
import 'package:instagram_clone/utils/constants/icons.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';
import 'Addcontentscreen/addcontentscreen.dart';
import 'HomeScreen/homescreen.dart';
import 'ProfileScreen/profilescreen.dart';
import 'ReelScreen/reelscreen.dart';

class NavigationBarScreen extends StatelessWidget {
  NavigationBarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigationBarController navigationBarController =
        Get.put(NavigationBarController());
    final UserController userController = Get.put(UserController());
    final WebRTCVideoController webRTCVideoController =
        Get.put(WebRTCVideoController());
    if (webRTCVideoController.videoCall.value.initiatorId != '') {}
    final isDark = AppHelperFunctions.isDarkMode(context);
    final color = isDark ? AppColors.white : AppColors.dark;
    return Scaffold(
      body: Obx(() => navigationBarController
          .screens[navigationBarController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () {
          final VideoCallModel video = webRTCVideoController.videoCall.value;
          final user = AuthenticationRepository.instance.authUser!.uid;
          print("cureent user is $user");
          print(
              "videocall value is ${video.roomId} status${video.status}, ${video.initiatorId}");
          print("condition 1  is ${video.initiatorId != user}");
          print("status of video ${video.status} and status 0 ${status['0']}");
          print("condition 2 is ${video.status == status['0']}");
          if (video.initiatorId != user && video.status == status['0']) {
            print("videoCAll value is ${video.initiatorId} ${video.roomId}");
            // Get.to(IncomingCallScreen(videoCall: video));
            // showIncomingCallScreen(context, video);
          }
          return BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              currentIndex: navigationBarController.selectedIndex.value,
              onTap: (value) =>
                  navigationBarController.selectedIndex.value = value,
              items: [
                BottomNavigationBarItem(
                  icon: AppIcons.hutIcon(color),
                  activeIcon: AppIcons.hutFilledIcon(color),
                  label: '',
                ),
                BottomNavigationBarItem(
                    icon: AppIcons.searchIcon(color),
                    activeIcon: AppIcons.searchFilledIcon(color),
                    label: ''),
                BottomNavigationBarItem(
                    icon: AppIcons.addIcon(color),
                    activeIcon: AppIcons.addFilledIcon(color),
                    label: ''),
                BottomNavigationBarItem(
                    icon: AppIcons.reelIcon(color),
                    activeIcon: AppIcons.reelFilledIcon(color),
                    label: ''),
                BottomNavigationBarItem(
                    icon: PostUploader(
                      size: 10,
                      image: UserController.instance.user.value.photoUrl,
                    ),
                    activeIcon: PostUploader(
                        size: 10,
                        image: UserController.instance.user.value.photoUrl),
                    label: ''),
              ]);
        },
      ),
    );
  }
}

class NavigationBarController extends GetxController {
  static NavigationBarController get instance => Get.find();
  RxInt selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    Searchscreen2(),
    UploadMenu(),
    ReelScreen(),
    ProfileScreen(),
  ];
}

void showIncomingCallScreen(BuildContext context, VideoCallModel videoCall) {
  // showModalBottomSheet(context: context, builder: (context) {
  //   return Container(
  //         width: AppHelperFunctions.screenWidth(context),
  //         height: 400,
  //         child: FutureBuilder(
  //             future: UserRepository.instance
  //                 .fetchUserWithGivenId(videoCall.initiatorId),
  //             builder: (context, snapshot) {
  //               if (snapshot.hasError) {
  //                 return Text("error fetching callerDetails");
  //               }
  //               if (!snapshot.hasData) {
  //                 return Text("error no data");
  //               }
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return Center(child: CircularProgressIndicator());
  //               }
  //               final caller = snapshot.data;
  //               return Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text("Incoming Call",
  //                       style: TextStyle(
  //                           fontSize: 24, fontWeight: FontWeight.bold)),
  //                   SizedBox(height: 20),
  //                   CircleAvatar(
  //                       radius: 50,
  //                       backgroundImage:
  //                           NetworkImage(caller!.photoUrl)), // Caller image
  //                   SizedBox(height: 20),
  //                   Text(caller.name, style: TextStyle(fontSize: 20)),
  //                   SizedBox(height: 20),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: () async {
  //                           Get.to(WebRtcVideoScreen(
  //                               videoCall: videoCall, receiverId: ''));
  //                           await WebRTCVideoController.instance
  //                               .updateDocStatus(
  //                                   videoCall.initiatorId, "accepted");
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Icon(Icons.call, color: Colors.white),
  //                         style: ElevatedButton.styleFrom(
  //                           shape: CircleBorder(),
  //                           backgroundColor: Colors.green,
  //                         ),
  //                       ),
  //                       ElevatedButton(
  //                         onPressed: () async {
  //                           await WebRTCVideoController.instance
  //                               .updateDocStatus(
  //                                   videoCall.initiatorId, "ended");
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Icon(Icons.call_end, color: Colors.white),
  //                         style: ElevatedButton.styleFrom(
  //                           shape: CircleBorder(),
  //                           backgroundColor: Colors.red,
  //                         ),
  //                       ),
  //                     ],
  //                   )
  //                 ],
  //               );
  //             }),
  //       );
  // });
  showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Container(
          width: AppHelperFunctions.screenWidth(context),
          height: 400,
          child: FutureBuilder(
              future: UserRepository.instance
                  .fetchUserWithGivenId(videoCall.initiatorId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("error fetching callerDetails");
                }
                if (!snapshot.hasData) {
                  return Text("error no data");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final caller = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Incoming Call",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(caller!.photoUrl)), // Caller image
                    SizedBox(height: 20),
                    Text(caller.name, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Get.to(WebRtcVideoScreen(
                                videoCall: videoCall, receiverId: ''));
                            await WebRTCVideoController.instance
                                .updateDocStatus(
                                    videoCall.initiatorId, "accepted");
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.call, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await WebRTCVideoController.instance
                                .updateDocStatus(
                                    videoCall.initiatorId, "ended");
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.call_end, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }),
        );
      });
}
