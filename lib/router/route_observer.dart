import 'package:flutter/material.dart';

class RouteLoggingObserver extends NavigatorObserver {

  static String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    print('📍 Pushed: ${route.settings.name}');
    print('⬅️ From: ${previousRoute?.settings.name}');
    currentRoute = route.settings.name;
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('🔙 Popped: ${route.settings.name}');
    print('➡️ Back to: ${previousRoute?.settings.name}');
    currentRoute = previousRoute?.settings.name;
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('🔁 Replaced: ${oldRoute?.settings.name} → ${newRoute?.settings.name}');
    currentRoute = newRoute?.settings.name;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
