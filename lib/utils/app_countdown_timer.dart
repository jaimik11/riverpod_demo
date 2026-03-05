import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class AppCountDownTimer extends StatefulWidget {
  const AppCountDownTimer({
    super.key,
    required this.secondsRemaining,
    required this.whenTimeExpires,
    this.countDownFormatter,
    // this.countDownTimerStyle,
    this.textColor = AppColors.neutral9,
    this.fontSize = 16,
    this.fontWeight = AppFontWeight.medium,
  });

  final int secondsRemaining;
  final VoidCallback whenTimeExpires;

  // final TextStyle? countDownTimerStyle;
  final Function(int seconds)? countDownFormatter;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  State createState() => _AppCountDownTimerState();
}

class _AppCountDownTimerState extends State<AppCountDownTimer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Duration duration;

  String get timerDisplayString {
    final duration = _controller.duration! * _controller.value;
    if (widget.countDownFormatter != null) {
      return widget.countDownFormatter!(duration.inSeconds) as String;
    } else {
      return formatHHMMSS(duration.inSeconds);
    }
  }

  String formatHHMMSS(int seconds) {
    final hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    final minutes = (seconds / 60).truncate();

    final hoursStr = (hours).toString().padLeft(2, '0');
    final minutesStr = (minutes).toString().padLeft(2, '0');
    final secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return '$minutesStr:$secondsStr';
    }

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.secondsRemaining);
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller
      ..reverse(from: widget.secondsRemaining.toDouble())
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          widget.whenTimeExpires();
        }
      });
  }

  @override
  void didUpdateWidget(AppCountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = Duration(seconds: widget.secondsRemaining);
        _controller.dispose();
        _controller = AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller
          ..reverse(from: widget.secondsRemaining.toDouble())
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.whenTimeExpires();
            }
          });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return Text(
          timerDisplayString,
          style: TextStyles.body2Medium.copyWith(fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,color: widget.textColor),
        );
      },
    );
  }
}
