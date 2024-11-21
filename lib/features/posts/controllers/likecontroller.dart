import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/posts/data/repository/likerepository.dart';

class LikeController extends GetxController {
  static LikeController get instance => Get.find();
  final LikeRepository likeRepository = Get.put(LikeRepository(),tag: UniqueKey().toString());
  final String postId;
  LikeController({required this.postId});
  Stream<List<String>> get likeStream =>
      likeRepository.getLikeStream(postId);

  Future<void> likePost(postId) async {
    try {
      await likeRepository.likePost(postId);
    } catch (e) {
      throw "could not like";
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await likeRepository.unlikePost(postId);
    } catch (e) {
      throw "could not unlike";
    }
  }

  
}
