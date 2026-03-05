import 'package:c2c/enums/text_color_type.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import 'app_text_field.dart';

class AppTextFieldHeader extends StatelessWidget {
  final String headerTxt;
  final TextStyle? headerTxtStyle;
  final TextFieldType textFieldType;

  const AppTextFieldHeader({
    super.key,
    required this.headerTxt,
    this.headerTxtStyle,
    this.textFieldType = TextFieldType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: headerTxt,
        style: (headerTxtStyle ?? TextStyles.body2Medium)
            .copyWith(color: TextColorType.inputHeading.resolve(context)),
        children: [
          switch (textFieldType) {
            TextFieldType.normal => const TextSpan(text: ''),
            TextFieldType.optional => TextSpan(
                text: ' (${context.translate.optional})',
                style: (headerTxtStyle ?? TextStyles.body2Medium)
                    .copyWith(color: TextColorType.inputHeading.resolve(context)),
              ),
            TextFieldType.required => TextSpan(
                text: '*',
                style: (headerTxtStyle ?? TextStyles.body2Medium)
                    .copyWith(color: TextColorType.defaultColor.resolve(context)),
              ),
          }
        ],
      ),
    );
  }
}
