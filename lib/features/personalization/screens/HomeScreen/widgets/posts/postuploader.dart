import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../../common/styles/dateTimeformatter.dart';
import '../../../../../../common/widgets/shimmer.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../data/models/usermodel.dart';
import '../../../../data/repositories/userrepository.dart';
class PostUploaderDetails extends StatelessWidget {
  PostUploaderDetails({
    super.key,
    required this.userId,
    required this.time,
  });

  final String userId;
  final Timestamp time;
  Rx<UserModel> user = UserModel.empty().obs;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: UserModel.empty(),
        future: UserRepository.instance.fetchUserWithGivenId(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("No data");
          }
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppShimmerEffect(
                width: AppHelperFunctions.screenWidth(context) * 0.8,
                height: 25);
          }
          user.value = snapshot.data!;
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceBtwItems),
                child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                        child: PostUploader(
                      size: 20,
                      image: user.value.photoUrl,
                    ))),
              ),
              Obx(() => Text(user.value.name)),
              Text("   ${formatTimeDifference(time.toDate())}"),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.ellipsisVertical,
                    size: AppSizes.iconMd,
                  ))
            ],
          );
        });
  }
}
class PostUploader extends StatelessWidget {
  const PostUploader({super.key, required this.size, required this.image});

  final String image; // Use final for immutability
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.transparent, // Optional: background color for empty image
      child: image.isEmpty
          ? FlutterLogo(size: size * 2) // Adjust size for FlutterLogo
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover, // Use BoxFit.cover to fill the circle
                width: size * 2, // Ensure the image fits the CircleAvatar
                height: size * 2, // Ensure the image fits the CircleAvatar
                placeholder: (context, url) =>const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>const Icon(Icons.error),
              ),
            ),
    );
  }
}
