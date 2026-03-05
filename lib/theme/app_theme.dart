import 'package:c2c/constants/app_ui_constants.dart';
import 'package:c2c/enums/text_color_type.dart';
import 'package:flutter/material.dart';
import 'package:picker_pro_max_ultra/platform_config.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../constants/app_constants.dart';
import '../constants/app_fonts.dart';
import 'text_styles.dart';
import '../../gen/fonts.gen.dart';
import 'app_colors.dart';

class AppTheme {
  // Light theme
  static ThemeData get lightTheme => ThemeData(
          extensions: const [
            SkeletonizerConfigData(),
            // default constructor has light theme config
          ],
          useMaterial3: true,
          brightness: Brightness.light,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.bg,
          canvasColor: AppColors.white,
          fontFamily: FontFamily.outfit,

          /// text field theme - light
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsetsDirectional.only(
              start: 12,
              end: 12,
              top: 16,
              bottom: 16,
            ),
            hintStyle:
                TextStyles.body1Regular.copyWith(color: AppColors.hintColor),
            floatingLabelStyle:
                TextStyles.caption1Regular.copyWith(color: AppColors.stroke),
            prefixStyle:
                TextStyles.body1Regular.copyWith(color: AppColors.black),
            errorStyle:
                TextStyles.caption1Regular.copyWith(color: AppColors.red),
            fillColor: AppColors.white,
            filled: true,
            enabledBorder: _getFieldInputBorder(borderColor: AppColors.stroke),
            focusedBorder: _getFieldInputBorder(borderColor: AppColors.primary),
            errorBorder: _getFieldInputBorder(borderColor: AppColors.red),
            focusedErrorBorder:
                _getFieldInputBorder(borderColor: AppColors.red),
            disabledBorder: _getFieldInputBorder(borderColor: AppColors.stroke),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.transparent),
                borderRadius:
                BorderRadius.circular(AppUiConstants.kButtonRadius),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.outfit,
              ),
              shadowColor: AppColors.transparent,
              elevation: 0,
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
              foregroundColor: AppColors.neutral9,
              disabledForegroundColor:
                  AppColors.neutral9.withValues(alpha: 0.4),
              iconColor: AppColors.neutral9,
              disabledIconColor: AppColors.neutral9.withValues(alpha: 0.4),
              minimumSize: Size(double.infinity, AppConstants.kButtonHeight),
            ),
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.bg,
            titleTextStyle: TextStyles.body1SemiBold,
            iconTheme: const IconThemeData(
              size: 20, // Icon size for all icons
              color: AppColors.black, // Default icon color
            ),
            actionsIconTheme: const IconThemeData(
              size: 20, // Icon size for all icons
              color: AppColors.black, // Default icon color
            ),
          ),
          /// divider theme - light
          dividerTheme: DividerThemeData(
            color: AppColors.stroke,
          ),

          /// progress indicator theme - light
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: AppColors.primary,
            linearTrackColor: AppColors.greyColor,
          ),
          popupMenuTheme: const PopupMenuThemeData(color: AppColors.white),
          dialogTheme: const DialogThemeData(backgroundColor: AppColors.white));

  // Dark theme
  static ThemeData get darkTheme => ThemeData(
          extensions: const [
            SkeletonizerConfigData.dark(),
            PickerThemeData(
              bottomSheetBackgroundColor: Colors.black,
              bottomSheetIndicatorColor: AppColors.primary,
              borderRadius: 10,
            ),
            // default constructor has light theme config
          ],
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.bg0,
          canvasColor: AppColors.bg0,
          primaryIconTheme: const IconThemeData(
            color: AppColors.textPrimary,
          ),

          /// text field theme - dark
          inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            hintStyle:
                TextStyles.body1Regular.copyWith(color: AppColors.hintColor),
            floatingLabelStyle: TextStyles.caption1Regular
                .copyWith(color: AppColors.white.withOpacity(0.6)),
            errorStyle:
                TextStyles.caption1Regular.copyWith(color: AppColors.red),
            enabledBorder: _getFieldInputBorder(borderColor: AppColors.grey950),
            focusedBorder: _getFieldInputBorder(borderColor: AppColors.grey950),
            errorBorder: _getFieldInputBorder(borderColor: AppColors.red),
            fillColor: AppColors.bg0,
            filled: true,
            focusedErrorBorder:
                _getFieldInputBorder(borderColor: AppColors.red),
            disabledBorder:
                _getFieldInputBorder(borderColor: AppColors.grey950),
          ),
          /// button theme - dark
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              splashFactory: InkRipple.splashFactory,
              overlayColor: Colors.black.withOpacity(0.15),
              shadowColor: AppColors.transparent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.transparent),
                borderRadius:
                    BorderRadius.circular(AppUiConstants.kButtonRadius),
              ),
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, AppConstants.kButtonHeight),
              disabledBackgroundColor: AppColors.primary,
              foregroundColor: AppColors.textDarkGrey,
              disabledForegroundColor: AppColors.textLightGrey,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.outfit,
              ),
            ),
          ),

          /// appbar theme - dark
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.bg0,
            titleTextStyle: TextStyles.body1SemiBold,
            foregroundColor: AppColors.textPrimary,
            surfaceTintColor: AppColors.bg0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),

          /// divider them - dark
          dividerTheme: const DividerThemeData(
            color: AppColors.grey950,
          ),

          /// progress indicator theme - dark
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: AppColors.primary,
            linearTrackColor: AppColors.grey950,
          ),

          /// popup menu - dark
          popupMenuTheme: const PopupMenuThemeData(
            color: AppColors.bg5,
            shadowColor: AppColors.bg5,
            elevation: 8,
          ),

          /// floating button - dark
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: AppColors.bg5)

          // todo: Add other theme properties as needed
          );

/*  static final appTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      canvasColor: AppColors.white,
      fontFamily: FontFamily.outfit,
      appBarTheme: const AppBarTheme(color: AppColors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.transparent),
            borderRadius:
            BorderRadius.circular(AppUiConstants.kButtonRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: FontFamily.outfit,
          ),
          shadowColor: AppColors.transparent,
          elevation: 0,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          foregroundColor: AppColors.neutral9,
          disabledForegroundColor: AppColors.neutral9.withValues(alpha: 0.4),
          iconColor: AppColors.neutral9,
          disabledIconColor: AppColors.neutral9.withValues(alpha: 0.4),
          minimumSize: Size(double.infinity, AppConstants.kButtonHeight),
        ),
      ),
      iconTheme: const IconThemeData(
        size: 20, // Icon size for all icons
        color: AppColors.black, // Default icon color
      ),

      /// text field theme - light
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsetsDirectional.only(
          start: 12,
          end: 12,
          top: 16,
          bottom: 16,
        ),
        hintStyle: TextStyles.body1Regular.copyWith(color: AppColors.hintColor),
        floatingLabelStyle:
            TextStyles.caption1Regular.copyWith(color: AppColors.stroke),
        prefixStyle: TextStyles.body1Regular.copyWith(color: AppColors.black),
        errorStyle: TextStyles.caption1Regular.copyWith(color: AppColors.red),
        enabledBorder: _getFieldInputBorder(borderColor: AppColors.stroke),
        focusedBorder: _getFieldInputBorder(borderColor: AppColors.primary),
        errorBorder: _getFieldInputBorder(borderColor: AppColors.red),
        focusedErrorBorder: _getFieldInputBorder(borderColor: AppColors.red),
        disabledBorder: _getFieldInputBorder(borderColor: AppColors.stroke),
      ),
      popupMenuTheme: const PopupMenuThemeData(color: AppColors.white));*/

  static InputBorder _getFieldInputBorder({
    required Color borderColor,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: BorderRadius.circular(AppUiConstants.kFieldBorderRadius),
    );
  }

}
