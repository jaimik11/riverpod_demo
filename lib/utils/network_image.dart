import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../gen/assets.gen.dart';
import '../theme/app_colors.dart';


class CommonProfileAvatar {
  /// profile image avatar
  static Widget commonProfileAvatar({
    double? sizedBoxHeight,
    void Function()? onTapProfile,
    double profileRadius = 40,
    String imageUrl = "",
    String placeholderString = "",
    Color dottedBorderColor = AppColors.black,
    Widget? stackedIcon,
    bool showBorder = true,
    double bottomPositionIcon = 0.7,
  }) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => onTapProfile?.call(),
      child: SizedBox(
        height: sizedBoxHeight ?? 110,
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageUrl != "" && !imageUrl.startsWith("http")
                ? SizedBox(
              height: profileRadius * 2,
              width: profileRadius * 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(imageUrl),
                    ),
                  ),
                ),
              ),
            )
                : CircleAvatar(
              backgroundColor: Colors.white,
              radius: profileRadius,
              child: loadNetworkImage(
                imageUrl,
                borderRadius: 60,
                isProfile: true,
                placeholderString: placeholderString,
              ),
            ),
            Positioned(
              child: stackedIcon ?? const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }





  static Widget loadNetworkImage(
      String url, {
        Color? color = Colors.white,
        double? borderRadius,
        double? width,
        double? height,
        BoxFit fit = BoxFit.fill,
        bool isProfile = false,
        String placeholderString = "",
        BlendMode? backgroundBlendMode,
      }) {
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute == true && url != "";
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        backgroundBlendMode: backgroundBlendMode,
        color: color,
        // border: Border.all(color: AppColors.fieldBorderColor.withOpacity(0.2), width: 2),
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        boxShadow: isProfile
            ? [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0.0, 0.0),
            blurRadius: 8,
          ),
        ]
            : [],
      ),
      child: isValidUrl
          ? ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          child: !url.endsWith('svg')
              ? CachedNetworkImage(
            imageUrl: url,
            fit: fit,
            progressIndicatorBuilder:
                (context, url, downloadProgress) {
              return Skeletonizer.zone(
                child: Bone(
                  height: height,
                  width: width,
                  borderRadius:
                  BorderRadius.circular(borderRadius ?? 0),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Image.network(
                url,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceHolderImage(
                        borderRadius, height, width),
                fit: BoxFit.fill,
              );
            },
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            child: SvgPicture.network(
              url,
              placeholderBuilder: (context) => Skeletonizer.zone(
                child: Bone(
                  height: height,
                  width: width,
                  borderRadius:
                  BorderRadius.circular(borderRadius ?? 0),
                ),
              ),
              fit: fit,
            ),
          ))
          : placeholderString != ""
          ? ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: Center(
          child: Image.file(
            File(placeholderString),
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      )
          : _buildPlaceHolderImage(borderRadius, height, width),
    );
  }


  /// placeholder image
  static Widget _buildPlaceHolderImage(
      double? borderRadius, double? height, double? width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: Center(
        child: Assets.images.svg.backIcon.svg(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }



}
