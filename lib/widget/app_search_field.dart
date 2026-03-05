import 'package:c2c/l10n/localization.dart';
import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import 'app_text_field.dart';

class AppSearchField extends StatelessWidget {
  TextEditingController controller;
  FocusNode? focusNode;
  String? hintText;
  final Function(String value)? onChanged;
  final Function()? onTap;
  final Function()? onClear;
  final Function? onEditingComplete;
  final Function? onFieldSubmitted;
  AppSearchField({super.key,required this.controller, this.hintText, this.onChanged, this.onTap, this.onClear, this.onEditingComplete, this.onFieldSubmitted,this.focusNode});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: hintText ?? context.translate.search,
      borderRadius: 100,
      focusedBorderColor: AppColors.primary,
      textEditingController: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.text,
      enabledBorderColor: AppColors.stroke,
      onChanged: (value){
        onChanged?.call(value);
      },
      onTap: () {
        onTap?.call();
      },
      onEditingComplete: () {
        onEditingComplete?.call();
      },
      contentPadding: const EdgeInsetsDirectional.only(
        top: 14,
        bottom: 14,
        start: 20,
      ),
      suffixWidget: Container(
        margin: const EdgeInsetsDirectional.only(end: 6),
        child: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Assets.images.svg.backIcon.svg(),
        ),
      ),
    );
  }
}
