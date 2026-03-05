import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../enums/text_color_type.dart';
import '../gen/assets.gen.dart';
import '../theme/text_styles.dart';
import 'app_button.dart';

class AppEmptyWidget extends StatelessWidget {
  String? imgPath;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool addListView;

  AppEmptyWidget({
    super.key,
    this.imgPath,
    required this.title,
    this.subtitle = "",
    this.buttonText,
    this.onPressed,
    this.addListView = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Allows pull to refresh
        if (addListView)
          ListView(physics: const AlwaysScrollableScrollPhysics()),

        // Empty view centered
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // img
              Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 24),
                  child: Skeleton.replace(
                    replacement: const Bone.circle(size: 60),
                    child:
                        extension(imgPath ?? Assets.images.svg.backIcon.path) == ".svg"
                        ? SvgPicture.asset(
                            imgPath ?? Assets.images.svg.backIcon.path,
                          )
                        : Image.asset(imgPath!),
                  ),
                ),
              ),

              // title
              if (title!.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 16),
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyles.body1SemiBold.copyWith(
                      color: TextColorType.defaultColor.resolve(context),
                    ),
                  ),
                ),

              // subtitle
              if (subtitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyles.body1Regular.copyWith(
                      color: TextColorType.defaultColor.resolve(context),
                    ),
                  ),
                ),

              // button
              if (buttonText != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 24),
                  child: Align(
                    alignment: Alignment.center,
                    child: AppButton(
                      onPressed: onPressed,
                      buttonText: buttonText!,
                      showNextArrow: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
