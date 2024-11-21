import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/notification/data/notificationModel.dart';
import 'package:instagram_clone/navigationscreen.dart';
import 'package:instagram_clone/utils/popups/loaders.dart';
import 'features/profile/data/repository/userrepository.dart';
import 'package:timezone/timezone.dart' as tz;

import 'features/videocall/model/videocallModel.dart';
import 'features/videocall/view/incomingcallScreen.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('instagram');
  static const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'High Importance Notifications', // Name
    description:
        'This channel is used for important notifications.', // Description
    importance: Importance.high,
  );
  static const AndroidNotificationDetails androidCallNotificationDetails =
      AndroidNotificationDetails(
          'high_importance_channel', 'High Importance Notifications',
          channelDescription: "Notification",
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('ringtone'),
          playSound: true,
          enableVibration: true,
          showWhen: true);
  static const AndroidNotificationDetails androidSimpleNotificationDetails =
      AndroidNotificationDetails('simpleNoti', "CommentFollow",
          playSound: true);
  static const NotificationDetails platformCallChannelSpecifics =
      NotificationDetails(android: androidCallNotificationDetails);
  static const NotificationDetails platformSimpleChannelSpecifics =
      NotificationDetails(android: androidSimpleNotificationDetails);
  static Future<void> initializeNotification() async {
    try {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          if (details.id == 0) {
            Get.offAll(const NavigationBarScreen());
          }
          if (details.id == 1) {
            if (details.payload != null) {
              print("Payloaf is not null");
              print("payload is ${details.payload}");
              final videoCallMap = jsonDecode(details.payload!);
              if (videoCallMap != null) {
                final videoCall = VideoCallModel.fromMap(videoCallMap);
                print("on click will go to ${videoCall.toJson()}");
                Get.to(IncomingCallScreen());
              }
            }
          }
        },
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      throw "Error while redirecting showing notificaiton ${e.toString()}";
    }
  }

  static Future<void> showScheduledNotifications(TimeOfDay? time) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      // tz.TZDateTime scheduledTime = tz.TZDateTime(
      //     tz.local, now.year, now.month, now.day, time!.hour, time.minute);
      // print("schedule time is $scheduledTime");
      tz.TZDateTime scheduledTime = now.add(const Duration(seconds: 10));
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
        print("after day");
      }
      print("Now scheduling");
      // await flutterLocalNotificationsPlugin.periodicallyShowWithDuration(
      //     2,
      //   "Ey hajur ekchoti eta hernus na",
      //   "Ghara jani haina ra.. Dashain ta aaye vanxa ta..",
      //    Duration(hours: 24),
      //    platformSimpleChannelSpecifics);
      await flutterLocalNotificationsPlugin
          .zonedSchedule(
              2,
              "Ey hajur ekchoti eta hernus na",
              "Ghara jani haina ra.. Dashain ta aaye vanxa ta..",
              scheduledTime,
              platformSimpleChannelSpecifics,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              matchDateTimeComponents: DateTimeComponents.time)
          .then((value) {
        AppLoaders.customToast(message: "Scheduled successfully notification");
      }).onError((error, stacktree) {
        AppLoaders.errorSnackBar(
            title: "ERror",
            message: "Error scheduling ntoification ${error.toString()}");
      });
      print("Scheduling done");
    } catch (e) {
      throw "Error showing scheduled Notifications${e.toString()}";
    }
  }

  static Future<void> showNotifications(NotificationModel notification) async {
    try {
      final user = await UserRepository.instance
          .fetchUserWithGivenId(notification.userId);
      
      await flutterLocalNotificationsPlugin.show(
          0,
          notification.type,
          "${notification.type == "follow" ? "${user.name} started following you" : "${user.name}commented on your post"} ",
          platformSimpleChannelSpecifics,
          payload: 'payload');
    } catch (e) {
      throw "Error in notification $e";
    }
  }

  static Future<void> showCallNotification(VideoCallModel videocall) async {
    try {
      print(
          "Show notification called with ${videocall.initiatorId} and ${videocall.status}");
      final caller = await UserRepository.instance
          .fetchUserWithGivenId(videocall.initiatorId);
      final payloadData = jsonEncode(videocall.toJson());
      await flutterLocalNotificationsPlugin.show(1, 'Incoming Call',
          "${caller.name} is calling you.", platformCallChannelSpecifics,
          payload: payloadData);
    } catch (e) {
      throw "Error showing Incoming Call Notification ${e.toString()}";
    }
  }
}
