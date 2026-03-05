import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_constants.dart';
import '../constants/app_fonts.dart';
import '../gen/assets.gen.dart';

class TopSnackBar extends StatelessWidget {
  final String message;
  final bool showAppIcon;
  final Color backgroundColor;
  final TextStyle textStyle;
  final VoidCallback? onCloseClick;
  final Icon? icon;
  final BoxDecoration? iconWithDecoration;

  const TopSnackBar({
    super.key,
    this.showAppIcon = true,
    required this.message,
    this.onCloseClick,
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.icon,
    this.iconWithDecoration,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 0),
            spreadRadius: 1,
            blurRadius: 20,
          ),
        ],
      ),
      width: double.infinity,
      child: Row(
        children: [
          // if (showAppIcon)
          //   SvgPicture.asset(
          //     Assets.images.svg.logoYellow.path,
          //     height: 24,
          //     width: 24,
          //   ),
          if (showAppIcon) const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.merge(textStyle),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ),
          if (icon != null)
            GestureDetector(
              onTap: onCloseClick,
              child: Container(
                height: 32,
                width: 32,
                margin: const EdgeInsets.all(10),
                decoration: iconWithDecoration,
                child: icon,
              ),
            ),
        ],
      ),
    );
  }
}

typedef ControllerCallback = void Function(AnimationController);

class ToastManager {
  static OverlayEntry? _currentEntry;
  static AnimationController? _currentController;
  static Timer? _dismissTimer;

  static Future<void> showToast(
      OverlayState overlayState,
      Widget child, {
        Duration animationDuration = const Duration(milliseconds: 250),
        Duration reverseAnimationDuration = const Duration(milliseconds: 180),
        Duration displayDuration = const Duration(milliseconds: 2000),
        VoidCallback? onTap,
        EdgeInsets padding = const EdgeInsets.all(16),
        Curve curve = Curves.easeOut,
        Curve reverseCurve = Curves.easeIn,
      }) async {
    // If a toast is already visible → dismiss first
    await _dismissCurrentToast();

    final controller = AnimationController(
      duration: animationDuration,
      reverseDuration: reverseAnimationDuration,
      vsync: overlayState,
    );

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: padding,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: controller,
                    curve: curve,
                    reverseCurve: reverseCurve,
                  ),
                ),
                child: GestureDetector(
                  onTap: onTap,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);

    _currentEntry = overlayEntry;
    _currentController = controller;

    await controller.forward();

    // Auto dismiss after duration
    _dismissTimer = Timer(displayDuration, () {
      _dismissCurrentToast();
    });
  }

  static Future<void> _dismissCurrentToast() async {
    if (_currentController != null && _currentEntry != null) {
      try {
        await _currentController!.reverse(); // animate out
      } catch (_) {}
      _currentEntry?.remove();
      _currentEntry = null;

      _currentController?.dispose();
      _currentController = null;

      _dismissTimer?.cancel();
      _dismissTimer = null;
    }
  }

  static void dismissCurrent() {
    _dismissCurrentToast();
  }
}

void showToast(
    String message, {
      bool success = true,
      bool showAppIcon = true,
      BoxDecoration? iconWithDecoration,
      Color? backgroundColor,
      Icon? icon,
      TextStyle? textStyle,
    }) {
  if (message.isEmpty) return;

  Future.delayed(Duration.zero, () {
    ToastManager.showToast(
      Overlay.of(AppConstants.globalKey.currentState!.context),
      TopSnackBar(
        onCloseClick: ToastManager.dismissCurrent,
        showAppIcon: showAppIcon,
        icon: icon,
        iconWithDecoration: iconWithDecoration,
        message: message,
        textStyle: textStyle ??
            Theme.of(AppConstants.globalKey.currentState!.context)
                .textTheme
                .bodyMedium!
                .merge(
              TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white,
                fontFamily: AppFontFamily.fontName,
              ),
            ),
        backgroundColor:
        backgroundColor ?? (success ? Colors.green : Colors.red),
      ),
    );
  });
}
