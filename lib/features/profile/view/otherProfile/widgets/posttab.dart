import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../posts/data/repository/postrepository.dart';

class OthersPostTabBar extends StatelessWidget {
  OthersPostTabBar({super.key, required this.userId});
  String userId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Postrepository.instance.fetchPostofUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(
              "error",
              style: Theme.of(context).textTheme.headlineSmall,
            );
          }
          if (!snapshot.hasData) {
            return const Text("No Posts");
          }
          return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                final post = snapshot.data?[index];
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(post!.postImage))),
                );
              });
        });
  }
}

