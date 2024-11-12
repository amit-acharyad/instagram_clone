import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/widgets/myappbar.dart';
import 'package:instagram_clone/features/authentication/controllers/logincontroller.dart';
import 'package:instagram_clone/localNotification.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/utils/constants/enums.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:workmanager/workmanager.dart';


const taskName = "usershowtask";


class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final AppSettingController _appSettingController =
      AppSettingController.instance;
  @override
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.globe),
              title: Text(AppLocalizations.of(context).language),
              onTap: () {
                _showBottomModalSheetLanguage(context);
              },
            ),
            ListTile(
              leading: const FaIcon(Icons.mode),
              title: Text(AppLocalizations.of(context).theme),
              onTap: () {
                _showBottomModalSheetMode(context);
              },
            ),
            ListTile(
              leading: const Text("test"),
              title: const Text("Test WorkManager"),
              onTap: () async {
                
                await Workmanager().registerPeriodicTask(taskName, taskName,
                    frequency: const Duration(minutes: 15),
                    initialDelay: const Duration(seconds: 10));
              },
            ),
            ListTile(
              leading: const Text("testCAncel"),
              title: const Text("Test WorkManager CAncel task"),
              onTap: () async {
                await Workmanager().cancelAll();
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clock),
              title: const Text("Schedule Reminder"),
              onTap: () async {
                TimeOfDay? time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  await LocalNotificationService.showScheduledNotifications(
                      time);
                  Get.showSnackbar(GetSnackBar(
                    title: "Reminder SChedueld",
                    message: "Succesfully schedule for ${time.hour}",
                    duration: const Duration(seconds: 2),
                  ));
                } else {
                  print("time not selected");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: loginController.logout,
            ),
            loginController.logginOut.value
                ? const Center(
                    child: Row(
                      children: [
                        Text("Logging Out"),
                        SizedBox(
                          height: 60,
                          width: 50,
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  _showBottomModalSheetLanguage(context) {
    showModalBottomSheet(
        elevation: AppSizes.cardElevation,
        context: context,
        builder: (context) {
          return SizedBox(
              height: 100,
              child: Column(
                children: [
                  Row(
                    children: [
                      Radio<Languages>(
                        value: Languages.english,
                        groupValue: _appSettingController.currentLanguage.value,
                        onChanged: (Languages? value) {
                          if (value != null) {
                            _appSettingController.updateLanguage(value);
                          }
                        },
                      ),
                      const Text('English'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<Languages>(
                        value: Languages.nepali,
                        groupValue: _appSettingController.currentLanguage.value,
                        onChanged: (Languages? value) {
                          if (value != null) {
                            _appSettingController.updateLanguage(value);
                          }
                        },
                      ),
                      const Text('नेपाली'),
                    ],
                  ),
                ],
              ));
        });
  }

  _showBottomModalSheetMode(context) {
    showModalBottomSheet(
        elevation: AppSizes.cardElevation,
        context: context,
        builder: (context) {
          return SizedBox(
              height: 200,
              child: Column(
                children: [
                  AppBar(
                    automaticallyImplyLeading: false,
                    title: Text(
                      AppLocalizations.of(context).chooseTheme,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Row(
                    children: [
                      Radio<AppThemes>(
                        value: AppThemes.lightMode,
                        groupValue:
                            _appSettingController.currentThemeMode.value,
                        onChanged: (AppThemes? value) {
                          if (value != null) {
                            _appSettingController.updateThemeMode(value);
                          }
                        },
                      ),
                      Text(AppLocalizations.of(context).lightTheme),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AppThemes>(
                        value: AppThemes.darkMode,
                        groupValue:
                            _appSettingController.currentThemeMode.value,
                        onChanged: (AppThemes? value) {
                          if (value != null) {
                            _appSettingController.updateThemeMode(value);
                          }
                        },
                      ),
                      Text(AppLocalizations.of(context).darkTheme),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<AppThemes>(
                        value: AppThemes.system,
                        groupValue:
                            _appSettingController.currentThemeMode.value,
                        onChanged: (AppThemes? value) {
                          if (value != null) {
                            _appSettingController.updateThemeMode(value);
                          }
                        },
                      ),
                      Text(AppLocalizations.of(context).systemTheme),
                    ],
                  ),
                ],
              ));
        });
  }
}

class AppSettingController extends GetxController {
  static AppSettingController get instance => Get.find();
  var currentThemeMode = AppThemes.system.obs;
  var currentLanguage = Languages.english.obs;

  void updateLanguage(Languages language) {
    currentLanguage.value = language;
    if (language == Languages.english) {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ne', 'NP'));
    }
  }
  void updateThemeMode(AppThemes mode) {
    currentThemeMode.value = mode;
    if (currentThemeMode.value == AppThemes.darkMode) {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (currentThemeMode.value == AppThemes.lightMode) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }
}
