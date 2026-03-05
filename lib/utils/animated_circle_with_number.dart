import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/*
class AnimatedCircleWithNumber extends StatefulWidget {
  final String number;

  const AnimatedCircleWithNumber({Key? key, required this.number}) : super(key: key);

  @override
  State<AnimatedCircleWithNumber> createState() => _AnimatedCircleWithNumberState();
}

class _AnimatedCircleWithNumberState extends State<AnimatedCircleWithNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 + (_controller.value * 0.2); // pulse effect

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
              child: Center(
                child: Text(
                  widget.number,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}*/
class ShadedCircleAnimation extends StatefulWidget {
  final String number;

  const ShadedCircleAnimation({super.key, required this.number});

  @override
  State<ShadedCircleAnimation> createState() => _ShadedCircleAnimationState();
}

class _ShadedCircleAnimationState extends State<ShadedCircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 100 * _scaleAnimation.value,
                height: 100 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: _opacityAnimation.value),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: _opacityAnimation.value),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),
          Text(
            widget.number,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),
        ],
      ),
    );
  }
}