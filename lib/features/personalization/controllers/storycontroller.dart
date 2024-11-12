import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/data/models/storymodel.dart';
import 'package:instagram_clone/data/repositories/storyrepository.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';

class Storycontroller extends GetxController {
  static Storycontroller get instance => Get.find();

  final RxBool isUploadingStory = false.obs;
  final StoryRepository storyRepository = Get.put(StoryRepository());

  List<Stream<List<Storymodel>>> get storyStreams =>
      storyRepository.getStoryStream();
  Stream<Storymodel> get ownStoryStream => storyRepository.fetchOwnStory();
  @override
  void onInit() async {
    // await viewStatusMapping();
    super.onInit();
  }

  Future<void> updateViewer(String storyId) async {
    try {
      
      await storyRepository.updateViewer(storyId);
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<void> uploadStory() async {
    try {
      final XFile? story =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      isUploadingStory.value = true;
      await storyRepository.uploadStory(story);
    } catch (e) {
      throw "something went wrong";
    } finally {
      isUploadingStory.value = false;
    }
  }
}
