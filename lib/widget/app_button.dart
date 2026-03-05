import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../theme/app_colors.dart';

class AppButton extends StatefulWidget {
  /// `onPressed: null` for disabled button
  final void Function()? onPressed;
  final String buttonText;
  final double? buttonRadius;

  /// `buttonHeight` and `buttonWidth` both not null for custom width height
  final double? buttonHeight;

  /// `buttonHeight` and `buttonWidth` both not null for custom width height
  final double? buttonWidth;
  final Color? borderColor;
  final Color? buttonColor;
  final TextStyle? textStyle;
  final Widget? buttonChild;
  final Widget? icon;
  final IconAlignment iconAlignment;
  final Color? shadowColor;
  final Color? overlayColor;
  final EdgeInsetsGeometry? buttonTextPadding;
  final TextAlign? textAlign;

  final bool showNextArrow;

  const AppButton({
    super.key,
    required this.onPressed,
    this.buttonText = '',
    this.buttonRadius,
    this.buttonHeight,
    this.buttonWidth,
    this.borderColor,
    this.buttonColor,
    this.textStyle,
    this.buttonChild,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.shadowColor,
    this.overlayColor,
    this.buttonTextPadding,
    this.textAlign,
    this.showNextArrow = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle? buttonStyle = Theme.of(context).elevatedButtonTheme.style;

    final RoundedRectangleBorder roundedRectangleBorder =
        buttonStyle?.shape?.resolve({}) as RoundedRectangleBorder;

    // button text style
    TextStyle buttonTextStyle =
        (buttonStyle!.textStyle!.resolve({}) ?? const TextStyle()).copyWith(
      fontSize: widget.textStyle?.fontSize,
      fontWeight: widget.textStyle?.fontWeight,
      fontFamily: widget.textStyle?.fontFamily,
    );

    Color? disabledIconColor = widget.onPressed == null
        ? AppColors.neutral9.withValues(alpha: 0.4)
        : null;

    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      style: buttonStyle.copyWith(
        padding: widget.buttonTextPadding != null
            ? WidgetStatePropertyAll(widget.buttonTextPadding)
            : buttonStyle.padding,
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          roundedRectangleBorder.copyWith(
            side: widget.borderColor != null
                ? BorderSide(color: widget.borderColor!)
                : roundedRectangleBorder.side,
            borderRadius: widget.buttonRadius != null
                ? BorderRadius.circular(widget.buttonRadius!)
                : roundedRectangleBorder.borderRadius,
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color?>(widget.buttonColor),
        foregroundColor:
            WidgetStateProperty.all<Color?>(widget.textStyle?.color),
        minimumSize: widget.buttonWidth != null && widget.buttonHeight != null
            ? WidgetStateProperty.all<Size?>(
                Size(
                  widget.buttonWidth!,
                  widget.buttonHeight!,
                ),
              )
            : null,
        textStyle: WidgetStateProperty.all<TextStyle?>(buttonTextStyle),
        shadowColor: WidgetStateProperty.all<Color?>(widget.shadowColor),
        overlayColor: WidgetStateProperty.all<Color?>(widget.overlayColor),
      ),
      label: widget.buttonChild ??
          Text(
            widget.buttonText,
            style: buttonTextStyle.copyWith(color: widget.textStyle?.color),
            textAlign: widget.textAlign ?? TextAlign.center,
          ),
      icon: widget.icon ??
          (widget.showNextArrow
              ? SvgPicture.asset(
                  "Assets.images.svg.logo.path",
                  matchTextDirection: true,
                  colorFilter: disabledIconColor != null
                      ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                      : ColorFilter.mode(
                          widget.textStyle?.color ?? AppColors.neutral9,
                          BlendMode.srcIn,
                        ),
                )
              : null),
      iconAlignment: widget.iconAlignment,
    );
  }
}
