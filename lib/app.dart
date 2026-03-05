import 'package:c2c/di/theme_notifier.dart';
import 'package:c2c/router/app_pages.dart';
import 'package:c2c/router/route_observer.dart';
import 'package:c2c/theme/app_theme.dart';
import 'package:c2c/utils/logger_util.dart';
import 'package:c2c/widget/app_annotated_region.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_constants.dart';
import 'di/local_notifier.dart';
import 'di/app_providers.dart';
import 'l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.watch(getConnectivityProvider);

    return AppAnnotatedRegion(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler
              .noScaling, // keep font size as it is (not as per system fonts)
        ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'C2C',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ref.watch(themeNotifierProvider).value,
          routerConfig: ref.read(myGoRouterProvider),
          locale: ref.watch(localeNotifierProvider).value,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // builder: (context, child) {
          //   return Overlay(
          //     initialEntries: [
          //       OverlayEntry(
          //         builder: (context) => child!,
          //       ),
          //     ],
          //   );
          // },
        ),
      ),
    );
  }
}
