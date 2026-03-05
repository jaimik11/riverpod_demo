import 'dart:async';

import 'package:flutter/material.dart';

class AddDelay {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  AddDelay({
    this.milliseconds = 600,
  });

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancelDelay() {
    _timer?.cancel();
  }
}
