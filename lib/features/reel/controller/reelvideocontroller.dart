import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelVideoController extends GetxController {
  RxBool isPlaying = false.obs;
  RxBool isInitialized = false.obs;
  final Uri reelUrl;
  ReelVideoController({required this.reelUrl});
  late VideoPlayerController videoPlayerController;
  late VoidCallback listener;
  
  void initializeReel() {
    

    videoPlayerController = VideoPlayerController.networkUrl(reelUrl)
      ..initialize().then((_) {
        isInitialized.value = true;
        videoPlayerController.play();
      });
    listener = () {
      if (videoPlayerController.value.position ==
          videoPlayerController.value.duration) {
        videoPlayerController.seekTo(Duration.zero);
        videoPlayerController.play();
      }
    };
    videoPlayerController.addListener(listener);
    
  }

  @override
  void onClose() {
    videoPlayerController.removeListener(listener);
    videoPlayerController.dispose();
    super.onClose();
  }

  void playpause() {
    if (isPlaying.value) {
      videoPlayerController.pause();

      isPlaying.value = false;
    } else {
      videoPlayerController.play();

      isPlaying.value = true;
    }
  }
}
