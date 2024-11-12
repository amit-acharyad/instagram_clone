import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/commentModel.dart';
import 'package:instagram_clone/data/models/postmodel.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/profileimagewidget.dart';

import '../../../../../../common/styles/readmoreless.dart';
import '../../../../../../common/widgets/shimmer.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../data/models/usermodel.dart';
import '../../../../data/repositories/userrepository.dart';

class SingleComment extends StatelessWidget {
  final CommentModel? comment;
  SingleComment({super.key, required this.comment});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserRepository.instance.fetchUserWithGivenId(comment!.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("No data");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppShimmerEffect(width: 500, height: 30);
          }
          if (snapshot.hasError) {
            return Text("error");
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

