import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// status and navigation brightness
enum SystemUiOverlayMode {
  light,
  dark,
  theme
}

class AppAnnotatedRegion extends StatefulWidget {
  final Widget child;
  final SystemUiOverlayMode systemUiOverlayMode;
  final Color? statusBarColor;

  /// Handle status bar and navigation bar theme
  const AppAnnotatedRegion({
    super.key,
    required this.child,
    this.systemUiOverlayMode = SystemUiOverlayMode.theme,
    this.statusBarColor,
  });

  @override
  State<AppAnnotatedRegion> createState() => _AppAnnotatedRegionState();
}

class _AppAnnotatedRegionState extends State<AppAnnotatedRegion> {
  @override
  Widget build(BuildContext context) {
    var themeBrightness = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: switch (widget.systemUiOverlayMode) {
        SystemUiOverlayMode.theme => systemOverlayStyle(
          androidStatusBarIcons:
          themeBrightness  ? Brightness.light : Brightness.dark,
          iosStatusBarBrightness:
          themeBrightness  ? Brightness.dark : Brightness.light,
        ),
        // Light mode
        SystemUiOverlayMode.light => systemOverlayStyle(
            androidStatusBarIcons: Brightness.dark,
            iosStatusBarBrightness: Brightness.light,
          ).copyWith(
            statusBarColor: widget.statusBarColor,
            systemNavigationBarColor: widget.statusBarColor,
            systemNavigationBarDividerColor: widget.statusBarColor,
          ),
        // Dark mode
        SystemUiOverlayMode.dark => systemOverlayStyle(
            androidStatusBarIcons: Brightness.light,
            iosStatusBarBrightness: Brightness.dark,
          ).copyWith(
            statusBarColor: widget.statusBarColor,
            systemNavigationBarColor: widget.statusBarColor,
            systemNavigationBarDividerColor: widget.statusBarColor,
          ),
      },
      child: widget.child,
    );
  }
}

/// `androidStatusBarIcons` : [Brightness.dark] (dark icons), [Brightness.light] (light icons)
///
/// `iosStatusBarBrightness` : [Brightness.light] (dark icons), [Brightness.dark] (light icons)
SystemUiOverlayStyle systemOverlayStyle({
  required Brightness androidStatusBarIcons,
  required Brightness iosStatusBarBrightness,
}) {
  return SystemUiOverlayStyle(
    // status bar color
    statusBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,

    // ios status bar brightness
    statusBarBrightness: iosStatusBarBrightness,

    // android status bar icons
    statusBarIconBrightness: androidStatusBarIcons,

    // navigation bar
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );
}
