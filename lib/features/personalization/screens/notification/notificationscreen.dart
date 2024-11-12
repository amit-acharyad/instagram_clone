import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/myappbar.dart';
import 'package:instagram_clone/features/personalization/controllers/notificationController.dart';
import 'package:instagram_clone/features/personalization/screens/notification/notification_tile.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          showBackArrow: true,
          title: Text(AppLocalizations.of(context).notifications,
              style: Theme.of(context).textTheme.headlineMedium)),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            child: StreamBuilder(
                stream: notificationController.notificationStreams,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {

                    return const Text("No Notifications");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return const Text("Loading Notifications");
                  }
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final notification = snapshot.data?[index];
                          return NotificationTile(
                              notificationModel: notification);
                        });
                  }
                  return const Text("Not null");
                })),
      ),
    );
  }
}
