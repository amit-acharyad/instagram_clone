import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/commentModel.dart';

class CommentRepository extends GetxController {
  CommentRepository get instance => Get.find();
  Stream<List<CommentModel>> fetchComments(String postId) {
    try {
      final data = FirebaseFirestore.instance
          .collection("Comments")
          .where('postId', isEqualTo: postId)
          .snapshots();
      final comments = data.map((snapshot) => snapshot.docs
          .map((document) => CommentModel.fromSnapshot(document))
          .toList());
      return comments;
    } catch (e) {
      throw "Could not fetch Comments";
    }
  }

  Future<void> uploadComment(CommentModel comment) async {
    try {
      await FirebaseFirestore.instance
          .collection("Comments")
          .doc()
          .set(comment.toJson());
    } catch (e) {
      throw "Could not upload Comment $e";
    }
  }
}
