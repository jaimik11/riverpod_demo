import 'package:c2c/theme/text_styles.dart';
import 'package:flutter/material.dart';

import '../enums/text_color_type.dart';
import '../theme/app_colors.dart';

class ChipWidget extends StatelessWidget {
  final String? title;
  const ChipWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: TextColorType.defaultColor.resolve(context,invertColor: true),
        border: Border.all(color: AppColors.primary),
      ),
      child: Text(
        title!,
        style: TextStyles.caption2Medium.copyWith(color: TextColorType.defaultColor.resolve(context)),
      ),
    );
  }

}
