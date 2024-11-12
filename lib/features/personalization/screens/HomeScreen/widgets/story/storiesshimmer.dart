import 'package:flutter/material.dart';

import '../../../../../../common/widgets/shimmer.dart';
import '../../../../../../utils/constants/sizes.dart';

class StoriesShimmer extends StatelessWidget {
  const StoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSizes.spaceBtwItems),
        child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: ((context, index) {
              return const Column(
                children: [
                  AppShimmerEffect(
                    height: 40 * 2,
                    width: 40 * 2,
                    radius: 40,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AppShimmerEffect(width: 50, height: 20)
                ],
              );
            }),
            separatorBuilder: (_, __) => const SizedBox(
                  width: AppSizes.spaceBtwItems,
                ),
            itemCount: 3),
      ),
    );
  }
}
