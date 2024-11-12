
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/features/authentication/presentation/screens/loginscreen.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/screens/navigationscreen.dart';
import 'package:instagram_clone/utils/popups/loaders.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  User? get authUser => _auth.currentUser;
  final storage = GetStorage();
  
  @override
  void onReady() {
    FlutterNativeSplash.remove();

    super.onReady();
  }

  void screenRedirect() async {
    if (storage.read("isLoggedIn") == true) {
      final controller = Get.put(UserController());
      await controller.fetchUserDetails();
      Get.offAll(const NavigationBarScreen());
    } else {
      Get.offAll(const Loginscreen());
    }
  }

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      storage.write("isLoggedIn", true);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Error logging in",
        message: e.toString(),
      ));
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Error logging in",
        message: e.toString(),
      ));
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Error logging in",
        message: e.toString(),
      ));
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Error logging in",
        message: e.toString(),
      ));
      throw "Something went Wrong please try again later..";
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error {
      throw "Something went Wrong please try again later..";
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error {
      throw "Something went Wrong please try again later..";
    }
  }

  Future<UserCredential> registerWithEmailPassword(
      String email, String password) async {
    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCred;
    } on FirebaseAuthException catch (e) {
      AppLoaders.errorSnackBar(title: "Error", message: e.code);
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      AppLoaders.errorSnackBar(title: "Error", message: e.code);

      print('Signupfailed in firebase exep');

      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      AppLoaders.errorSnackBar(title: "Error", message: e.code);

      throw AppPlatformException(e.code);
    } on Error catch (e) {
      AppLoaders.errorSnackBar(title: "Error", message: e.toString());

      throw "Something went Wrong please try again later..";
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication authentication =
          await userAccount!.authentication;
      final OAuthCredential credentials = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credentials);
      storage.write("isLoggedIn", true);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLoaders.errorSnackBar(title: "AuthError", message: e.code);

      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      AppLoaders.errorSnackBar(title: "FirebaseError", message: e.code);

      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      print("platform error ${e.code}");
      AppLoaders.errorSnackBar(
          title: "PlatformError", message: e.code.toString());

      throw AppPlatformException(e.code);
    } on Error catch (e) {
      AppLoaders.errorSnackBar(title: "OtherError", message: e.toString());

      throw "Something went Wrong please try again later..";
    }
  }

  Future<void> logout() async {
    try {

      await GetStorage().erase();
      await DefaultCacheManager().emptyCache();
      // Directory tempDir = await getTemporaryDirectory();
      // if (await tempDir.exists()) {
      //   await tempDir.delete(recursive: true);
      // }
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error {
      throw "Something went Wrong please try again later..";
    }
  }
}
