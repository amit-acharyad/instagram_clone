import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_clone/features/notification/data/notificationModel.dart';
import 'package:instagram_clone/features/notification/data/notifcationRepository.dart';
import 'package:instagram_clone/localNotification.dart';

class NotificationController extends GetxController {
  final NotifcationRepository notifcationRepository = NotifcationRepository();

  Stream<List<NotificationModel>> get notificationStreams =>
      notifcationRepository.getCombinedNotificationsStream();
  @override
  void onInit() {
    GetStorage().writeIfNull('previous', 0);
    final previous = GetStorage().read('previous');
    notificationStreams.listen((notification) async {
      notification.sort((a, b) => a.time.compareTo(b.time));
      if (notification.isNotEmpty && notification.length > previous) {
        try {
          await LocalNotificationService.showNotifications(notification.first);
        } catch (e) {
          throw "Error while showing notification${e.toString()}";
        }
      }
    });
    super.onInit();
  }

  
}
