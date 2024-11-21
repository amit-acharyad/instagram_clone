import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_clone/features/authentication/presentation/screens/loginscreen.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/features/profile/view/settings.dart';
import 'package:instagram_clone/navigationscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  App({super.key});
  final AppSettingController appSettingController =
      Get.put(AppSettingController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        locale: const Locale('en', 'US'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('ne', 'NP')],
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: GetStorage().read('isLoggedIn')
            ? const NavigationBarScreen()
            : const Loginscreen());
  }
}
