import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/profile/controller/usercontroller.dart';
import 'package:instagram_clone/features/profile/data/repository/userrepository.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/features/search/view/searchScreen2.dart';
import 'package:instagram_clone/features/message/view/widgets/webrtcVideoScreen.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/icons.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';
import 'features/addcontent/addcontentscreen.dart';
import 'features/home/homescreen.dart';
import 'features/profile/view/ownProfile/profilescreen.dart';
import 'features/reel/view/reelscreen.dart';
import 'features/videocall/controller/videoCallChecker.dart';

class NavigationBarScreen extends StatelessWidget {
  const NavigationBarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigationBarController navigationBarController =
        Get.put(NavigationBarController());
    VideoCallChecker.getIncomingVideoCall();

  
    final isDark = AppHelperFunctions.isDarkMode(context);
    final color = isDark ? AppColors.white : AppColors.dark;
    return Scaffold(
      body: Obx(() => navigationBarController
          .screens[navigationBarController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () {

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
    const Searchscreen2(),
    const UploadMenu(),
    ReelScreen(),
    ProfileScreen(),
  ];
}
