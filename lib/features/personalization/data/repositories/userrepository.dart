import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/data/models/usermodel.dart';
import 'package:instagram_clone/utils/exceptions/platform_exceptions.dart';
import 'package:instagram_clone/utils/popups/loaders.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;
  final authInstance = AuthenticationRepository.instance;
  Future<void> saveUserInfo(UserModel user) async {
    try {
      final data = user.toJson();
      await db.collection('Users').doc(authInstance.authUser!.uid).set(data);
      print("User saved successfully");
    } on FirebaseAuthException catch (e) {
      print("error while saving");
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      print("error while saving");
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      print("error while saving");
      throw AppPlatformException(e.code);
    } on Error {
      print("error while saving");
      throw "Something went Wrong please try again later..";
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      final data = updatedUser.toJson();
      await db.collection("Users").doc(updatedUser.id).update(data);
      AppLoaders.successSnackBar(title: "Suceessfully Saved");
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

  Future<void> updateField(Map<String, dynamic> data) async {
    try {
      
      await db.collection("Users").doc(authInstance.authUser!.uid).update(data);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code);
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code);
    } on Error catch (e) {
      print("Error hile updating photoUrl $e");
      throw "Something went Wrong please try again later..";
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
     
      final user =
          await db.collection("Users").doc(authInstance.authUser!.uid).get();
      final userModel = UserModel.fromSnapshot(user);
      return userModel;
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

  Future<String> uploadImage(XFile? image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref('Users/Profile')
          .child(authInstance.authUser!.uid);

      await ref.putFile(File(image!.path));
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
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

  Future<UserModel> fetchUserWithGivenId(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .get();
      final user = UserModel.fromSnapshot(snapshot);
      return user;
    } catch (e) {
      throw "Error while fetchingUser$e";
    }
  }
}
