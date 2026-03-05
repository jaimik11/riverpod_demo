import 'package:c2c/constants/app_size_constants.dart';
import 'package:c2c/constants/app_ui_constants.dart';
import 'package:c2c/enums/text_color_type.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/theme/text_styles.dart';
import 'package:c2c/utils/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../constants/app_fonts.dart';
import '../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../widget/app_button.dart';
import '../widget/network_image.dart';
import 'common_methods.dart';
import 'logger_util.dart';

class CommonSheet {
  static Future<void> showAppBottomSheet({
    required Widget content,
    Widget? titleWidget,
    String title = "",
    bool isDismissible = true,
    bool enableDrag = true,
    bool allowInsetsBottom = false,
    EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 10),
    VoidCallback? onPositiveTap,
    VoidCallback? onNegativeTap,
    VoidCallback? onCrossIconTap,
    String positiveButtonText = "",
    String negativeButtonText = "",
  }) {
    return showModalBottomSheet(
      context: AppConstants.globalKey.currentContext!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: TextColorType.defaultColor.resolve(
        AppConstants.globalKey.currentContext!,
        invertColor: true,
      ),
      isScrollControlled: true,
      // Allows dynamic height
      useSafeArea: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              // bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            ),
            child: Wrap(
              // Wrap allows bottom sheet to take only required height
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.stroke,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title
                if (titleWidget != null)
                  titleWidget
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyles.subtitle2Bold.copyWith(
                          color: TextColorType.defaultColor.resolve(
                            AppConstants.globalKey.currentContext!,
                          ),
                        ),
                      ),

                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          onCrossIconTap?.call();
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(),
                ),

                // Content
                Padding(
                  padding: allowInsetsBottom
                      ? EdgeInsets.only(
                          bottom: MediaQuery.of(
                            context,
                          ).viewInsets.bottom, // pushes above keyboard
                        )
                      : contentPadding,
                  child: content,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    spacing: 14,
                    children: [
                      negativeButtonText.isNotEmpty
                          ? Expanded(
                              child: AppButton(
                                onPressed: () => onNegativeTap?.call(),
                                buttonText: negativeButtonText,
                                buttonColor: AppColors.white,
                                borderColor: AppColors.neutral2,
                                buttonRadius: AppSizeConstants.kBorderRadius,
                              ),
                            )
                          : const SizedBox(),

                      positiveButtonText.isNotEmpty
                          ? Expanded(
                              child: AppButton(
                                onPressed: () => onPositiveTap?.call(),
                                buttonText: positiveButtonText,
                                buttonColor: AppColors.primary,
                                buttonRadius: AppSizeConstants.kBorderRadius,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  static Widget buildListTileShowReasonToAddProduct(
      String icon,
      String title,
      BuildContext context,
      int count,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*CircleAvatar(
            backgroundColor: AppColors.bg3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: NetworkImageWidget(
                url: icon,
                width: 40,
                height: 40,
                // borderRadius: 100,
              ),
            ),
          ),*/
          Image.asset(icon,width: 40,
            height: 40,),
          Expanded(
            child: Text(
              title,
              style: TextStyles.subtitle2Medium.copyWith(
                color: TextColorType.defaultColor.resolve(context),
              ),
            ),
            // Column(
            //   spacing: 6,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //
            //     // Text(
            //     //   subTitle,
            //     //   style: TextStyles.body1Regular.copyWith(
            //     //     height: 1.2,
            //     //     color: TextColorType.neutral6.resolve(context),
            //     //   ),
            //     // ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }

  static Widget buildListTile(
    String icon,
    String title,
    String subTitle,
    BuildContext context,
    int count,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*CircleAvatar(
            backgroundColor: AppColors.bg3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: NetworkImageWidget(
                url: icon,
                width: 40,
                height: 40,
                // borderRadius: 100,
              ),
            ),
          ),*/
          NetworkImageWidget(
            url: icon,
            width: 40,
            height: 40,
            borderRadius: 100,
          ),
          Expanded(
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.subtitle2Medium.copyWith(
                    color: TextColorType.defaultColor.resolve(context),
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyles.body1Regular.copyWith(
                    height: 1.2,
                    color: TextColorType.neutral6.resolve(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildListStepperTile({
    required String icon,
    required String stepNo,
    required String title,
    required String subTitle,
    required int index,
    required BuildContext context,
    required int listLength,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              // Flexible(child: VerticalDivider(
              //   color: index != 0 ? AppColors
              //       .stroke : AppColors
              //       .transparent,)),
              SvgPicture.asset(icon),
              Flexible(
                child: VerticalDivider(
                  endIndent: 20,
                  indent: 10,
                  thickness: 2,
                  color: index != listLength - 1
                      ? AppColors.stroke
                      : AppColors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    stepNo,
                    style: TextStyles.caption1Regular.copyWith(
                      color: TextColorType.neutral6.resolve(context),
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyles.body1Medium.copyWith(
                      color: TextColorType.defaultColor.resolve(context),
                    ),
                  ),
                  SizedBox(height: 5),

                  Text(
                    subTitle,
                    // "TextStyles.subtitle2Medium.copyWith(color: TextColorType.defaultColor.resolve(context),",
                    style: TextStyles.body1Regular.copyWith(
                      height: 1.2,
                      color: TextColorType.neutral6.resolve(context),
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
