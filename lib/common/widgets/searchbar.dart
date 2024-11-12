import 'package:flutter/material.dart';

import '../../localizations/app_localizations.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';

class AppSearchbar extends StatefulWidget {
  
  @override
  State<AppSearchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<AppSearchbar> {
  
  @override
  Widget build(BuildContext context) {
    final bool isDark = AppHelperFunctions.isDarkMode(context);
    return SizedBox(
      height: AppSizes.xl,
      child: TextFormField(
        
        
        showCursor: false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(AppSizes.xs),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            disabledBorder: border,
            enabledBorder: border,
            border: border,
            focusedBorder: border,
            filled: true,
            fillColor: isDark ? AppColors.darkerGrey : Colors.grey[200],
            
            prefixIcon: Icon(
              Icons.search,
              size: AppSizes.iconXs,
            ),
            labelText: AppLocalizations.of(context).search),
      ),
    );
  }
}
final OutlineInputBorder border= OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm));
