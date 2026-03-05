import 'dart:io';

import 'package:c2c/enums/text_color_type.dart';
import 'package:c2c/theme/app_colors.dart';
import 'package:c2c/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomRadioOption<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T?> onChanged;

  const CustomRadioOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged.call(value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Transform.translate(
              offset: Directionality.of(context) == TextDirection.rtl
                  ? const Offset(6, 0)   // shift right in RTL
                  : const Offset(-6, 0),
              child: Radio<T>(
                value: value,
                groupValue: groupValue,
                onChanged: (value) {
                  onChanged.call(value);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(vertical: -4), // <-- ⭐ FIX
                activeColor: AppColors.primary,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary; // selected inner circle
                  } else {
                    return AppColors.stroke; // this affects the border for some Material versions
                  }
                }),
              ),
            ),
          ),
          Expanded(
            child: Text(label,style: TextStyles.body1Regular.copyWith(
              color: TextColorType.neutral9.resolve(context),
            )),
          ),
        ],
      ),
    );
  }
}
