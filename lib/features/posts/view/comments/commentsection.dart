import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/posts/data/model/postmodel.dart';
import 'package:instagram_clone/features/posts/controllers/commentController.dart';
import 'package:instagram_clone/features/posts/view/comments/commentbox.dart';
import 'package:instagram_clone/features/posts/view/comments/singlecomment.dart';

import '../../../../localizations/app_localizations.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final CommentController commentController = Get.put(
        CommentController(postId: post.postId),
        tag: UniqueKey().toString());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context).comments,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  StreamBuilder(
                      stream: commentController.commentStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child:
                                Text(AppLocalizations.of(context).noComments),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final comment = snapshot.data?[index];
                                return SingleComment(comment: comment);
                              });
                        }
                      }),
                ],
              ),
            ),
            const Spacer(),
            CommentBox(postId: post.postId)
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
