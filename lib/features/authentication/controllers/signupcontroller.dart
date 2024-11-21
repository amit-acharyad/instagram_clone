import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/authentication/presentation/screens/loginscreen.dart';
import 'package:instagram_clone/features/profile/data/model/usermodel.dart';
import 'package:instagram_clone/features/profile/data/repository/userrepository.dart';
import 'package:instagram_clone/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:instagram_clone/utils/exceptions/format_exceptions.dart';
import 'package:instagram_clone/utils/exceptions/platform_exceptions.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  RxBool showPassword = false.obs;
  RxBool tapped = false.obs;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final UserRepository userRepository = UserRepository.instance;
  GlobalKey<FormState> signupKey = GlobalKey<FormState>();
  void toggleShowHide() {
    showPassword.value = !showPassword.value;
  }

  void toggleTapped() {
    tapped.value = !tapped.value;
  }

  Future<void> signUpWithEmailPassword() async {
    try {
      if (!signupKey.currentState!.validate()) {
        print("could not validate form");
        print(signupKey.currentState!.validate());
        return;
      }
      print(signupKey.currentContext);
      print(signupKey.currentState!.validate());

      final user = await AuthenticationRepository.instance
          .registerWithEmailPassword(
              emailController.text.trim(), passwordController.text.trim());
      final userModel = UserModel(
          bio: '',
          gender: '',
          id: user.user!.uid,
          name: nameController.text.trim(),
          userName: emailController.text.trim(),
          photoUrl: '');
      print('reacherd before saving');
      await userRepository.saveUserInfo(userModel);

      Get.to(const Loginscreen());
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on FormatException {
      throw const AppFormatException();
    }
  }
}
