import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_clone/features/personalization/data/models/usermodel.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:instagram_clone/app.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/localNotification.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;

// Future<void> _firebaseMessagingBackgroundHandler(
//     RemoteMessage remoteMessage) async {
//   if (remoteMessage.notification != null) {
//     print(
//         "Message has notification ${remoteMessage.notification!.title} ${remoteMessage.notification!.body}");
//     await _showLocalNotifications(remoteMessage);
//   }
//   if (remoteMessage.data.isNotEmpty) {
//     print("Data is ${remoteMessage.data}");
//   }
// }

// Future<void> _showLocalNotifications(RemoteMessage message) async {
//   String payload =
//       message.data.isNotEmpty ? message.data.toString() : 'No data';

//   const AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//           "high_importance_channel", "High Importance Notifications",
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true);
//   const NotificationDetails platformDetails =
//       NotificationDetails(android: androidNotificationDetails);
//   await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
//       message.notification!.body, platformDetails,
//       payload: payload);
// }
void callBackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
     
     
      try {
         WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase within the background task
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform, // Use the appropriate options for your platform
      );
       final doc =
          await FirebaseFirestore.instance.collection("Users").limit(1).get();

      final oneUser = UserModel.fromSnapshot(doc.docs.first);
       
        await LocalNotificationService.flutterLocalNotificationsPlugin.show(
            3,
            oneUser.name,
            "The above mentioned user is one of the user of app",
            LocalNotificationService.platformCallChannelSpecifics);
        return Future.value(true);
      } catch (e) {
        throw "Error in workManager";
        
      }
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  GetStorage().writeIfNull('isLoggedIn', false);
  GetStorage().writeIfNull('previous', 0);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  tz.initializeTimeZones();
  await LocalNotificationService.initializeNotification();

  await FirebaseAppCheck.instance
      .activate(
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.appAttest,
      )
      .then(
        (value) => Get.put(AuthenticationRepository()),
      );
  Workmanager().initialize(
    callBackDispatcher,
    isInDebugMode: true,
  );
  runApp(App());
}
