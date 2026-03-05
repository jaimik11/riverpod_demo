// import 'package:flutter/material.dart';
//
// import '../theme/app_colors.dart';
// import '../theme/text_styles.dart';
//
// class RatingBarWidget extends StatefulWidget {
//   final List<bool> starsList;
//   final Function(List<bool> starsList)? onRatingChange;
//
//   const RatingBarWidget({super.key, required this.starsList, this.onRatingChange});
//
//   @override
//   State<RatingBarWidget> createState() => _RatingBarWidgetState();
// }
//
// class _RatingBarWidgetState extends State<RatingBarWidget> {
//   late List<bool> _stars;
//   int _lastTappedIndex = -1; // To trigger animation only for tapped star
//
//   @override
//   void initState() {
//     super.initState();
//     _stars = List.from(widget.starsList);
//   }
//
//   void _updateRating(int index) {
//     setState(() {
//       for (int i = 0; i < _stars.length; i++) {
//         _stars[i] = i <= index;
//       }
//       _lastTappedIndex = index; // Store last tapped index for animation
//     });
//
//     widget.onRatingChange?.call(_stars);
//
//     // Reset animation effect after a delay
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (mounted) {
//         setState(() => _lastTappedIndex = -1);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       spacing: 6,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             _stars.length,
//                 (index) => InkWell(
//               highlightColor: Colors.transparent,
//               splashColor: Colors.transparent,
//               onTap: () => _updateRating(index),
//               child: AnimatedScale(
//                 duration: const Duration(milliseconds: 200),
//                 scale: _lastTappedIndex == index ? 1.3 : 1.0, // Pop effect
//                 child: Icon(
//                   _stars[index] ? Icons.star : Icons.star_border,
//                   color: AppColors.primary,
//                   size: 40,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         _stars.where((t)=>t).length == 5 ? Text("Great 5 stars! Can’t get any better than that",
//           style: TextStyles.body1Regular.copyWith(color: AppColors.neutral6),) : const SizedBox(),
//       ],
//     );
//   }
// }

import 'package:c2c/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../enums/text_color_type.dart';
import '../gen/assets.gen.dart';
import '../theme/app_colors.dart';

class RatingBarWidget extends StatefulWidget {
  final double initial;
  final Size size;
  final int itemCount;
  final ValueChanged<double>? onRatingUpdate;
  final bool ignoreGestures;
  final EdgeInsetsGeometry itemPadding;

  const RatingBarWidget({
    Key? key,
    this.initial = 5,
    required this.size,
    this.itemCount = 5,
    this.onRatingUpdate,
    this.ignoreGestures = false,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 1),
  }) : super(key: key);

  @override
  _RatingBarWidgetState createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();

    _currentRating = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return widget.ignoreGestures ? RatingBar(
      itemCount: widget.itemCount,
      allowHalfRating: false,
      itemSize: widget.size.height,
      glow: false,
      tapOnlyMode: false,
      ignoreGestures: widget.ignoreGestures,
      initialRating: _currentRating,
      itemPadding: widget.itemPadding,
      ratingWidget: RatingWidget(
        full: Assets.images.svg.backIcon.svg(),
        half: Assets.images.svg.backIcon.svg(
          colorFilter: ColorFilter.mode(AppColors.neutral3, BlendMode.srcIn),
        ),
        empty: Assets.images.svg.backIcon.svg(
          colorFilter: ColorFilter.mode(AppColors.neutral3, BlendMode.srcIn),
        ),
      ),
      onRatingUpdate: (value) {
        setState(() {
          _currentRating = value;
        });
        if (widget.onRatingUpdate != null) {
          widget.onRatingUpdate!(value);
        }
      },
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingBar(
          itemCount: widget.itemCount,
          allowHalfRating: false,
          itemSize: widget.size.height,
          glow: false,
          tapOnlyMode: false,
          ignoreGestures: widget.ignoreGestures,
          initialRating: _currentRating,
          itemPadding: widget.itemPadding,
          ratingWidget: RatingWidget(
            full: Assets.images.svg.backIcon.svg(),
            half: Assets.images.svg.backIcon.svg(
              colorFilter: ColorFilter.mode(AppColors.neutral3, BlendMode.srcIn),
            ),
            empty: Assets.images.svg.backIcon.svg(
              colorFilter: ColorFilter.mode(AppColors.neutral3, BlendMode.srcIn),
            ),
          ),
          onRatingUpdate: (value) {
            setState(() {
              _currentRating = value;
            });
            if (widget.onRatingUpdate != null) {
              widget.onRatingUpdate!(value);
            }
          },
        ),
        if (_currentRating == 5)
          Column(
            children: [
              const SizedBox(height: 8),
              Text(
                "Great 5 stars! Can’t get any better than that",
                style: TextStyles.body1Regular.copyWith(color: TextColorType.neutral6.resolve(context)),
              ),
            ],
          ),
      ],
    );
  }
}

