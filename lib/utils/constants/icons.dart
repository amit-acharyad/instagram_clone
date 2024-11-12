import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/constants/imagestrings.dart';

import 'colors.dart';

class AppIcons {
  static Widget _iconContainer(String assetPath, double size) {
    return Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(assetPath), fit: BoxFit.contain)));
  }

  //reelIcons
  static Widget reelIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.reel_light
          : AppImageStrings.reel_dark,
      32);

  static Widget reelFilledIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.reel_filled_light
          : AppImageStrings.reel_filled_dark,
      32);

  //hutIcons
  static Widget hutIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.hut_light
          : AppImageStrings.hut_dark,
      28);

  static Widget hutFilledIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.hut_filled_light
          : AppImageStrings.hut_filled_dark,
      28);

  //AddIcon
  static Widget addFilledIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.add_light_filled
          : AppImageStrings.add_dark_filled,
      26);

  static Widget addIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.add_light
          : AppImageStrings.add_dark,
      26);

  //search
  static Widget searchFilledIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.search_filled_light
          : AppImageStrings.search_filled_dark,
      26);

  static Widget searchIcon(Color color) => _iconContainer(
      color == AppColors.white
          ? AppImageStrings.search_light
          : AppImageStrings.search_dark,
      26);
}
