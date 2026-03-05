// /// Enum for different text color types
// enum TextColorType {
//   defaultColor,
//   neutral9,
// }

import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Enum with associated colors
enum TextColorType {
  defaultColor(AppColors.bg0, AppColors.white),
  bgColor(AppColors.bg, AppColors.bg0),
  neutral6WithBlack(AppColors.neutral6, AppColors.bg0),
  neutral6(AppColors.neutral6, AppColors.textPrimary),
  neutral9(AppColors.neutral9, AppColors.textPrimary),
  inputHeading(AppColors.inputHeading, AppColors.white),
  borderStroke(AppColors.stroke, AppColors.grey950),
  bg2Color(AppColors.bg2, AppColors.bg0),
  tertiary7Color(AppColors.tertiary7Color, AppColors.bg0),
  defaultWhiteColor(AppColors.white,AppColors.bg0, );

  final Color lightModeColor;
  final Color darkModeColor;

  const TextColorType(this.lightModeColor, this.darkModeColor);

  /// Automatically resolves color based on theme mode
  Color resolve(BuildContext context, {bool invertColor = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final effectiveDarkMode = invertColor ? !isDarkMode : isDarkMode;
    return effectiveDarkMode ? darkModeColor : lightModeColor;
  }
}
