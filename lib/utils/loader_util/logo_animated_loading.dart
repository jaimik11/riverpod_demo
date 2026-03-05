import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../../theme/app_colors.dart';


class LogoAnimatedLoading extends StatefulWidget {
  const LogoAnimatedLoading({
    super.key,
    this.size,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  State<LogoAnimatedLoading> createState() => _LogoAnimatedLoadingState();
}

class _LogoAnimatedLoadingState extends State<LogoAnimatedLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _tween = Tween<double>(begin: 0.9, end: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size ?? 90,
      width: widget.size ?? 90,
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SvgPicture.asset(
            "Assets.images.svg.logo.path",
            colorFilter: ColorFilter.mode(
              widget.color ?? AppColors.white,
              BlendMode.srcIn,
            ),
            height: 24,
            width: 24,
            // color: widget.color ?? Theme.of(context).primaryColorLight,
          ),
        ),
      ),
    );
  }
}
