import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CountdownText extends StatefulWidget {
  final int initialSeconds;
  final TextStyle? textStyle;
  final VoidCallback? onTimerComplete;

  const CountdownText({
    Key? key,
    required this.initialSeconds,
    this.textStyle,
    this.onTimerComplete,
  }) : super(key: key);

  @override
  _CountdownTextState createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late int remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.initialSeconds;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onTimerComplete?.call(); // Notify when timer completes
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(formatTime(remainingSeconds), style: TextStyles.body1Medium.copyWith(color: AppColors.black),);
  }
}
