import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_clone/features/personalization/controllers/messagecontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/notificationController.dart';
import 'package:instagram_clone/features/personalization/screens/message/messagescreen.dart';
import 'package:instagram_clone/features/personalization/screens/notification/notificationscreen.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/imagestrings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBar({super.key});
  RxBool showRedDot = false.obs;

  @override
  Widget build(BuildContext context) {
    GetStorage().writeIfNull('previous', 0);
    int previousNotificationCount = GetStorage().read('previous');
    final bool isDark = AppHelperFunctions.isDarkMode(context);
    final Color color = isDark ? AppColors.white : AppColors.dark;
    final NotificationController notificationController =
        Get.put(NotificationController());
    final MessageController messageController = Get.put(MessageController());
    return AppBar(
      automaticallyImplyLeading: false,
      title: Image.asset(
        isDark ? AppImageStrings.whiteInstaLogo : AppImageStrings.darkInstaLogo,
        height: 40,
        width: 120,
        fit: BoxFit.contain,
      ),
      actions: [
        StreamBuilder(
            stream: notificationController.notificationStreams,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int current = snapshot.data!.length;
                if (current > previousNotificationCount) {
                  showRedDot.value = true;
                }
                previousNotificationCount = current;
                GetStorage().write('previous', previousNotificationCount);
              }
              return Obx(
                () => Stack(
                  children: [
                    IconButton(
                        onPressed: () {
                          showRedDot.value = false;

                          Get.to(NotificationScreen());
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.heart,
                          color: color,
                        )),
                    Positioned(
                        right: 3,
                        top: 6,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: showRedDot.value
                              ? Colors.red
                              : Colors.transparent,
                        ))
                  ],
                ),
              );
            }),
        Stack(
          children: [
            IconButton(
                onPressed: () => Get.to(MessageScreen()),
                icon: FaIcon(
                  FontAwesomeIcons.facebookMessenger,
                  color: color,
                )),
            Obx((){
              if(messageController.count.value==0){
                return const SizedBox();
              }
              else {return Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 10,
                            // ignore: sort_child_properties_last
                            child:
                                Center(child: Text(messageController.count.value.toString())),
                            backgroundColor: Colors.red,
                          ),
                        );}
            })
          
               
            
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);
}
