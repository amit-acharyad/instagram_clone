import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_clone/features/authentication/controllers/signupcontroller.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/authentication/presentation/screens/loginscreen.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/utils/popups/full_screen_loader.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>(debugLabel: "l1");

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository.instance;
  final UserController userController = Get.put(UserController());
  final obscureText = true.obs;
  final tapped = false.obs;
  final RxBool loggingIn = false.obs;
  final RxBool logginOut = false.obs;
  void toggleShowHide() {
    obscureText.value = !obscureText.value;
  }

  Future<void> loginwithEmailPassword() async {
    try {
      loggingIn.value = true;
      if (!loginKey.currentState!.validate()) {
        return;
      }

      print(emailController.text);

      await authenticationRepository.signInWithEmailPassword(
          emailController.text.trim(), passwordController.text.trim());
      print('login successful');
      authenticationRepository.screenRedirect();
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      throw "Something went Wrong please try again later..";
    } finally {
      loggingIn.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final userCredentials = await authenticationRepository.signInWithGoogle();
      userController.saveUserInfo(userCredentials);
      authenticationRepository.screenRedirect();
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      throw "Something went Wrong please try again later..";
    }
  }

  Future<void> logout() async {
    try {
      logginOut.value = true;
      print("LogginOut value is ${logginOut.value}");
      await authenticationRepository.logout();
      // await SystemNavigator.pop();
      Get.offAll(Loginscreen());
      print("Still ${logginOut.value}");
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      throw "Something went Wrong please try again later..";
    } finally {
      logginOut.value = false;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await authenticationRepository.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      throw "Something went Wrong please try again later..";
    }
  }

  Future<void> forgotPassword() async {
    try {
      await authenticationRepository
          .forgotPassword(emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      throw "Something went Wrong please try again later..";
    }
  }
}
