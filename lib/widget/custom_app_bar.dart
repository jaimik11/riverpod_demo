import 'package:c2c/enums/text_color_type.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? customTitle;
  final String titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBottomDivider;
  final PreferredSizeWidget? customBottom;
  final bool showBackIcon;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBackPress;
  final double? titleSpacing;
  final Color? backgroundColor;
  final double leadingWidth;
  final double toolbarHeight;

  const CustomAppBar({
    super.key,
    this.customTitle,
    this.titleText = "",
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.showBottomDivider = false,
    this.customBottom,
    this.showBackIcon = true,
    this.onBackPress,
    this.titleSpacing = -10,
    this.backgroundColor,
    this.leadingWidth = 56,
    this.toolbarHeight = kToolbarHeight
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth:  leadingWidth,
      toolbarHeight: toolbarHeight,
      scrolledUnderElevation: 0,
      leading: showBackIcon
          ? IconButton(
              onPressed: () {
                if (onBackPress != null) {
                  onBackPress!.call();
                } else {
                  context.pop();
                }
              },
              icon: Assets.images.svg.backIcon.svg(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).appBarTheme.iconTheme?.color ??
                      AppColors.black,
                  BlendMode.srcIn,

                ),
                matchTextDirection: true
              ),
            )
          : SizedBox(),
      titleSpacing: titleSpacing,
      backgroundColor: backgroundColor,
      title:  customTitle ?? Text(titleText,style: TextStyles.body1SemiBold.copyWith(color: TextColorType.defaultColor.resolve(context)),),
      actions: actions,
      centerTitle: centerTitle,
      bottom: showBottomDivider && customBottom == null
          ? PreferredSize(
              preferredSize:
                  const Size.fromHeight(1.0), // Height of the divider
              child: Container(
                color:
                TextColorType.borderStroke.resolve(context),
                height: 1.0,
              ),
            )
          : customBottom,
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(toolbarHeight);
}
