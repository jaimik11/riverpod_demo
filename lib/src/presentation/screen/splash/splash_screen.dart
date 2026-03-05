import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/theme/app_colors.dart';
import 'package:c2c/theme/text_styles.dart';
import 'package:c2c/widget/app_scaffold.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../enums/profile_details_type.dart';
import '../../../../enums/screen_state.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../router/app_routes.dart';
import '../personal_details/personal_details_args.dart';
import 'notifier/splash_notifier.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final state = ref.watch(splashNotifierProvider);
        final notifier = ref.read(splashNotifierProvider.notifier);
        print("state.screenState ${state.screenState} state.path ${state.path} state.animationEnd ${state.animationEnd}");
        if (state.screenState == ScreenState.done && state.path.isNotEmpty && state.animationEnd) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.path == AppRoute.personalDetails.path) {
              print("ifffff");
              context.pushReplacement(
                state.path,
                extra: PersonalDetailsArgs(
                  type: ProfileDetailsType.createProfile,
                ),
              );
            }
            // else if (state.path == Routes.homeStreetDeals) {
            //   notifier.handlePendingNotification();
            // }
            else {
              print("elseelseelseelseelseelse");

              context.pushReplacement(state.path);
            }
          });
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent, // transparent status bar
            systemNavigationBarColor: Colors.transparent, // transparent nav bar
          ),
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0.0,
                        end: 1.0,
                      ), // from invisible + tiny -> visible + full size
                      duration: const Duration(
                        milliseconds: 2100,
                      ), // smooth duration
                      curve: Curves.easeInOut, // smoother animation
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value, // scaling
                          child: Opacity(
                            opacity: value, // fading
                            child: child,
                          ),
                        );
                      },
                      // child: Assets.images.svg.splashBg.svg(width: 120, height: 120),
                      onEnd: () {
                        print("animationEnd------");
                        // Trigger navigation AFTER animation completes
                        notifier.animationEndMethod(true);

                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
