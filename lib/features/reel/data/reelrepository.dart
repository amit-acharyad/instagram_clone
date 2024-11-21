import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/reel/data/reelModel.dart';
import 'package:instagram_clone/features/profile/controller/usercontroller.dart';

class Reelrepository extends GetxController {
  static Reelrepository get instance => Get.find();
  final reelsRef = FirebaseStorage.instance.ref("Reels/Userreels");
  Future<List<ReelModel>> fetchReels() async {
    try {
      final snapshots =
          await FirebaseFirestore.instance.collection("Reels").get();
      final reels =
          snapshots.docs.map((reel) => ReelModel.fromSnapshot(reel)).toList();
      return reels;
    } catch (e) {
      throw "Error fetching Reels";
    }
  }

  Future<void> uploadReel(XFile? reel) async {
    try {
      await reelsRef.putFile(File(reel!.path));
      final reelUrl = await reelsRef.getDownloadURL();
      final reelId = DateTime.timestamp().millisecondsSinceEpoch.toString();
      final reelModel = ReelModel(
          reelId: reelId,
          uploaderId: UserController.instance.user.value.id,
          uploaderName: UserController.instance.user.value.name,
          reelUrl: reelUrl);
      await FirebaseFirestore.instance
          .collection("Reels")
          .doc()
          .set(reelModel.json());
    } catch (e) {
      throw ("Error uploading Reels");
    }
  }

  Future<List<ReelModel>> fetchReelsOfUser(String Id) async {
    try {
      final reels = await FirebaseFirestore.instance
          .collection("Reels")
          .where('uploaderId', isEqualTo: Id)
          .get();
      final reelModels =
          reels.docs.map((reel) => ReelModel.fromSnapshot(reel)).toList();
      return reelModels;
    } catch (E) {
      throw "Error fetching reels${E.toString()}";
    }
  }
}
