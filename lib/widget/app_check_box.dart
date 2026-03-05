import 'package:c2c/gen/assets.gen.dart';
import 'package:c2c/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../enums/text_color_type.dart';
import '../theme/text_styles.dart';

class AppCheckBox extends StatelessWidget {
  final bool isSelected;
  final Function(bool)? onCheck;
  final String? text;
  final TextStyle? textStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const AppCheckBox({
    super.key,
    this.isSelected = false,
    required this.onCheck,
    this.text,
    this.textStyle,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCheck?.call(!isSelected);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: !isSelected
                  ? Border.all(
                color: AppColors.stroke,
                width: 2,
              )
                  : null,
              color: isSelected ? AppColors.primary : AppColors.white,
            ),
            child: isSelected
                ? Transform.scale(
              scale: 0.6,
              child: Assets.images.svg.backIcon.svg(),
            )
                : null,
          ),
          if (text != null) SizedBox(width: spacing),
          if (text != null)
            Expanded(
              child: Text(
                text!,
                style: textStyle ??
                    TextStyles.body1Regular.copyWith(
                      color: TextColorType.neutral9.resolve(context),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

