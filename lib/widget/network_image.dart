import 'package:c2c/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../gen/assets.gen.dart';

class NetworkImageWidget extends StatelessWidget {

  final String url;
  final Color? color;
  final double? borderRadius;
  final double? width;
  final double? height;
  final BoxFit fit ;
  final bool isProfile;
  final String placeholderString ;
  final EdgeInsetsGeometry placeholderPadding;
  final BlendMode? backgroundBlendMode;

   const NetworkImageWidget({
    super.key,
  required this.url,
  this.color = Colors.white,
   this.borderRadius,
   this.width,
   this.height,
   this.placeholderPadding = const EdgeInsets.all(0),
  this.fit = BoxFit.cover,
  this.isProfile = false,
  this.placeholderString = "",
  this. backgroundBlendMode,
  });



  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute == true && url != "";
    // Helper to check if the URL is an SVG
    bool isSvg(String url) => url.toLowerCase().endsWith('.svg');
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
      child:
          isValidUrl
              ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius ?? 0),
                child:
                    isSvg(url)
                        ? SvgPicture.network(
                          url,
                          width: width,
                          height: height,
                          fit: fit ?? BoxFit.cover,
                          placeholderBuilder:
                              (context) => Skeletonizer.zone(
                                child: Bone(
                                  height: height,
                                  width: width,
                                  borderRadius: BorderRadius.circular(
                                    borderRadius ?? 0,
                                  ),
                                ),
                              ),
                        )
                        : CachedNetworkImage(
                          imageUrl: url,
                          fit: fit,
                          progressIndicatorBuilder: (
                            context,
                            url,
                            downloadProgress,
                          ) {
                            return Skeletonizer.zone(
                              child: Bone(
                                height: height,
                                width: width,
                                borderRadius: BorderRadius.circular(
                                  borderRadius ?? 0,
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            print("errorWidget $url");
                            return _buildPlaceHolderImage(
                              borderRadius,
                              height,
                              width,
                              placeholderPadding
                            );
                          },
                        ),
              )
              : _buildPlaceHolderImage(borderRadius, height, width,placeholderPadding),
    );
  }


  Widget _buildPlaceHolderImage(
       double? borderRadius, double? height, double? width, EdgeInsetsGeometry? placeholderPadding) {

    String initials = _getInitials(placeholderString);

    return ClipRRect(
       borderRadius: BorderRadius.circular(borderRadius ?? 0),
       child: Center(
         child: Padding(
           padding:  placeholderPadding ?? EdgeInsets.zero,
           child: placeholderString.isNotEmpty && initials.isNotEmpty
               ? Container(
             width: width ?? 50,
             height: height ?? 50,
             decoration: BoxDecoration(
               color: _getColorFromName(placeholderString), // background for initials avatar
               borderRadius: BorderRadius.circular(borderRadius ?? 0),
             ),
             child: Center(
               child: Text(
                 initials,
                 style: TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.bold,
                   fontSize: (width ?? 50) * 0.4,
                 ),
               ),
             ),
           )
               : Assets.images.svg.backIcon.svg(
             width: width ?? double.infinity,
             height: height ?? double.infinity,
             fit: BoxFit.cover,
           ),
         ),
         ),
    );

   }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "";
    List<String> parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    } else {
      return (parts.first[0] + parts.last[0]).toUpperCase(); // DS from Darpan Shah
    }
  }

  Color _getColorFromName(String name) {
    if (name.trim().isEmpty) return Colors.grey; // default fallback
    final int hash = name.hashCode;
    final int index = hash % avatarColors.length;
    return avatarColors[index];
  }
}

const List<Color> avatarColors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.indigo,
  Colors.brown,
  Colors.cyan,
  Colors.pink,
];
