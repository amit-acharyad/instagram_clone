import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.showBackArrow, this.title, this.actions});
  final bool showBackArrow;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final color = isDark ? AppColors.white : AppColors.dark;
    return AppBar(
      leading: showBackArrow
          ? IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: color,
              ))
          : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);
}
