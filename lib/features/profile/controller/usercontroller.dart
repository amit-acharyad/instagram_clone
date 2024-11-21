import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/profile/data/model/usermodel.dart';
import 'package:instagram_clone/features/profile/data/repository/userrepository.dart';
import 'package:instagram_clone/utils/popups/loaders.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  Rx<UserModel> user = UserModel.empty().obs;
  final UserRepository userRepository = Get.put(UserRepository());
  final GlobalKey editProfileKey = GlobalKey<FormState>();
  RxString gender = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void onInit() async {
    await fetchUserDetails();
    gender(user.value.gender);
    nameController.text = user.value.name;
    usernameController.text = user.value.userName;
    bioController.text = user.value.bio;
    super.onInit();
  }

  Future<void> saveUserInfo(UserCredential userCredential) async {
    try {
      final user1 = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? "",
          bio: '',
          gender: '',
          userName: userCredential.user!.displayName!
              .toLowerCase()
              .removeAllWhitespace,
          photoUrl: userCredential.user!.photoURL ?? "");

      await userRepository.saveUserInfo(user1);
    } catch (e) {
      AppLoaders.errorSnackBar(
          title: 'User Info Could not be Saved',
          message: 'Something went wrong. Please try again later');
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      final user = await userRepository.fetchUserDetails();
      print("User fetched successfully ${user.name}");
      this.user(user);
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

  Future<void> uploadImage() async {
    try {
      print("reached uploadImage");
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      final photoUrl = await userRepository.uploadImage(image);
      print(photoUrl);
      Map<String, dynamic> json = {'photoUrl': photoUrl};
      await userRepository.updateField(json).then((e) {
        print("Successfully updated Field");
      });
      AppLoaders.successSnackBar(title: 'Image Added');
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      AppLoaders.errorSnackBar(
          title: "Image failed to upload", message: e.toString());
      throw "Something went Wrong please try again later..";
    }
  }

  Future<void> updateUser() async {
    try {
      UserModel updatedUser = UserModel(
          id: user.value.id,
          name: nameController.text.trim(),
          userName: usernameController.text.trim(),
          gender: gender.value,
          bio: bioController.text.trim(),
          photoUrl: user.value.photoUrl);
      await userRepository.updateUser(updatedUser);
    } catch (e) {
      AppLoaders.errorSnackBar(title: "Error", message: e.toString());
      throw "Something went wrong";
    }
  }

  Future<void> updateUserGender(String genderValue) async {
    try {
      gender.value = genderValue;
    } catch (e) {
      AppLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
      throw "Something went wrong";
    }
  }

  
}
