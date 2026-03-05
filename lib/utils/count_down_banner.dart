import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class LiveTimerWidget extends StatefulWidget {
  const LiveTimerWidget({super.key});

  @override
  _LiveTimerWidgetState createState() => _LiveTimerWidgetState();
}

class _LiveTimerWidgetState extends State<LiveTimerWidget> {
  late StreamController<String> _timeStreamController;

  @override
  void initState() {
    super.initState();
    _timeStreamController = StreamController<String>();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      DateTime now = DateTime.now();
      String formattedTime = "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')} | "
          "${_getWeekday(now.weekday)}";

      _timeStreamController.add(formattedTime);
    });
  }

  String _getWeekday(int day) {
    const List<String> weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    return weekdays[day - 1];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _timeStreamController.stream,
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? "Loading...",
          style: TextStyles.caption1Medium.copyWith(color: AppColors.red),
        );
      },
    );
  }

  @override
  void dispose() {
    _timeStreamController.close();
    super.dispose();
  }
}
