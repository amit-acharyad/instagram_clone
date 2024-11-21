import 'package:flutter/material.dart';
import 'package:instagram_clone/features/posts/data/model/commentModel.dart';

import '../../../../common/styles/readmoreless.dart';
import '../../../../common/widgets/shimmer.dart';
import '../../../profile/data/repository/userrepository.dart';

class SingleComment extends StatelessWidget {
  final CommentModel? comment;
  const SingleComment({super.key, required this.comment});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserRepository.instance.fetchUserWithGivenId(comment!.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("No data");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppShimmerEffect(width: 500, height: 30);
          }
          if (snapshot.hasError) {
            return const Text("error");
          }
          final user = snapshot.data;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 16.0 / 2),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoUrl),
              radius: 28,
            ),
            title: Text(user.name),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 16.0 / 2),
              child: ReadMoreLess(
                data: comment!.comment
                  ),
                ),
              );}
            );
          
        }
  
  }

