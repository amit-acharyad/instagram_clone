import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/shimmer.dart';
import '../../../../../../utils/constants/sizes.dart';

class PostShimmer extends StatelessWidget {
   PostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.spaceBtwItems),
      child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            return  Column(
              children: [
                AppShimmerEffect(
                  height: AppHelperFunctions.screenHeight(context)*0.5,
                  width: AppHelperFunctions.screenWidth(context)*0.8,
                  radius: 2,
                ),
                
              ],
            );
          }),
          separatorBuilder: (_, __) => const SizedBox(
                width: AppSizes.spaceBtwItems,
              ),
          itemCount: 5),
    );
  }
}
