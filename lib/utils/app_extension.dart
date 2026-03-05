import 'package:flutter/material.dart';

import '../enums/text_color_type.dart';
import '../theme/app_colors.dart';

extension ContextUtil on BuildContext {
  /// hide keyboard
  void hideKeyboard() {
    if (mounted) {
      FocusScope.of(this).requestFocus(FocusNode());
    }
  }

  /// Get color based on the theme and `textColorType`
  ///
  /// `invertColor: true` invert theme mode
  Color getTextColor({
    required TextColorType textColorType,
    bool invertColor = false,
  }) {
    ThemeData theme = Theme.of(this);
    bool isDarkMode = theme.brightness == Brightness.dark;

    if (invertColor) {
      isDarkMode = !isDarkMode;
    }

    switch (textColorType) {
      case TextColorType.defaultColor:
        return isDarkMode ? AppColors.bg0 : AppColors.white;
        case TextColorType.neutral9:
        return isDarkMode ? AppColors.textSecondary : AppColors.neutral9;
    // TODO: Add more cases as needed
      default:
        return isDarkMode ? AppColors.white : AppColors.bg0;
    }
  }
}

extension StringUtils on String? {
  bool isNotNullOrEmpty() {
    String? value = this;
    if (value != null && value.isNotEmpty) {
      return true;
    }
    return false;
  }

   String capitalizeFirst() {
    String s = this.toString();
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}
