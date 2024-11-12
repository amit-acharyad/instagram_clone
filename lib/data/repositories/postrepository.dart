import 'package:get/get.dart';
import '../models/postmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Postrepository extends GetxController {
  static Postrepository get instance => Get.find();
  Future<List<PostModel>> fetchPostofUser(String userId) async {
    try {
      final posts = await FirebaseFirestore.instance
          .collection("Posts")
          .where('userId', isEqualTo: userId)
          .get();
      final postModels =
          posts.docs.map((post) => PostModel.fromSnapshot(post)).toList();
      return postModels;
    } catch (e) {
      throw "Error fetching posts";
    }
  }

  Future<PostModel> fetchPost(String postId) async {
    try {
      final post = await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .get();
      return PostModel.fromSnapshot(post);
    } catch (e) {
      throw "Error fetching post";
    }
  }
}
