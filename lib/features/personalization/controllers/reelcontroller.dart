import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/data/models/reelModel.dart';
import 'package:instagram_clone/data/repositories/reelrepository.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/utils/popups/loaders.dart';

class Reelcontroller extends GetxController {
  RxList<ReelModel> reels = <ReelModel>[].obs;
  RxList<ReelModel> ownReels = <ReelModel>[].obs;
  final Reelrepository reelrepository = Get.put(Reelrepository());
  static Reelcontroller get instance => Get.find();
  RxBool isUploadingReel = false.obs;
  @override
  void onInit() async {
    super.onInit();
    await fetchReels();
  }

  Future<void> fetchReels() async {
    try {
      final reelModels = await reelrepository.fetchReels();
      reels.assignAll(reelModels);
      final ownReel = reels
          .where((reel) =>
              reel.uploaderId ==
              AuthenticationRepository.instance.authUser!.uid)
          .toList();
      ownReels.assignAll(ownReel);
    } catch (e) {
      throw ("Something went wrong while fetching Reels");
    }
  }

  Future<List<ReelModel>> fetchReelsOfUser(String Id) async{
    try {
     return await reelrepository.fetchReelsOfUser(Id);
    } catch (E) {
      throw "Error fetching reels${E.toString()}";
    }
  }

  Future<void> uploadReels() async {
    try {
      final XFile? reel =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      isUploadingReel.value = true;
      await reelrepository.uploadReel(reel);
    } catch (e) {
      AppLoaders.errorSnackBar(
          title: "Error", message: "Could not upload Reel ${e.toString()}");
      throw "something went wrong";
    } finally {
      isUploadingReel.value = false;
      AppLoaders.successSnackBar(
          title: "Upload Successful", message: "Reel Uploaded Successfully");
    }
  }

  Future<Uint8List?> generateThumbnail(String videoUrl) async {
    try {
      print('genrate thumbNail called');
      final thumbNail = await VideoThumbnail.thumbnailData(
          video: videoUrl,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 128,
          quality: 75);
      print("thumNail is ${thumbNail.elementSizeInBytes}");
      return thumbNail;
    } catch (e) {
      print("error $e");
      throw "Error generating thumbNail";
    }
  }
}
