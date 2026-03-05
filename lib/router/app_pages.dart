
import 'package:c2c/router/app_routes.dart';
import 'package:c2c/src/presentation/screen/personal_details/personal_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_constants.dart';
import '../src/presentation/screen/personal_details/personal_details_args.dart';
import '../src/presentation/screen/splash/splash_screen.dart';

part 'app_pages.g.dart';

final routeObserver = RouteObserver();
@Riverpod(keepAlive: true)
GoRouter myGoRouter(Ref ref) {
  return GoRouter(
    observers: [routeObserver],//,RouteLoggingObserver()
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: true,
    navigatorKey: AppConstants.globalKey,
    routes: [
      //Driver@1234
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: AppRoute.personalDetails.path,
        name: AppRoute.personalDetails.name,
        builder: (context, state) => PersonalDetailsScreen(
          args: state.extra as PersonalDetailsArgs,
        ),
      ),
    ],
  );
}

