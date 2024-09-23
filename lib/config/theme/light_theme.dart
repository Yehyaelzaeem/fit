import 'package:flutter/material.dart';

import '../../core/resources/resources.dart';

ThemeData lightTheme(BuildContext context) {
  bool isAr = true;

  return ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.offWhite,

    /// Color scheme
    colorScheme: const ColorScheme.light().copyWith(primary: AppColors.primary),

    /// Bottom sheet
    bottomSheetTheme: const BottomSheetThemeData(elevation: AppSize.s8),

    /// Appbar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: AppSize.s0,
      iconTheme: IconThemeData(color: AppColors.primary),
    ),

    /// Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),

    /// Icon theme
    iconTheme: const IconThemeData(color: AppColors.primary),

    /// Tabbar theme
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: AppColors.darkGrey,
      labelColor: AppColors.white,
      unselectedLabelStyle: TextStyle(
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontWeight: FontWeightManager.regular,
      ),
      labelStyle: TextStyle(
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontWeight: FontWeightManager.semiBold,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8),
        color: AppColors.primary,
      ),
    ),
  );
}
