import 'dart:async';
import 'dart:io';

import 'package:c2c/enums/notification_type.dart';
import 'package:c2c/enums/user_type.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/services/my_notification_manager.dart';
import 'package:c2c/src/data/repository/remote/remote_repository.dart';
import 'package:c2c/utils/common_methods.dart';
import 'package:c2c/widget/app_dialog.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../constants/storage_constants.dart';
import '../../../../../di/app_providers.dart';
import '../../../../../enums/app_status.dart' show AppStatus;
import '../../../../../enums/screen_state.dart';
import '../../../../../enums/upload_type.dart';
import '../../../../../router/app_routes.dart';
import '../../../../../utils/logger_util.dart';
import '../../../../data/repository/local/local_repository.dart';
import '../../../../domain/model/init_model/init_model.dart';
import '../state/splash_state.dart';

part 'splash_notifier.g.dart';

@riverpod
class SplashNotifier extends _$SplashNotifier {
  LocalRepository? localRepository = ProviderContainer().read(
    localRepositoryProvider,
  );
  RemoteRepository? remoteRepository = ProviderContainer().read(
    remoteRepositoryProvider,
  );
  bool animationEnd = false;

  Timer? fallbackTimer;

  @override
  SplashState build() {
    _removeBadge();

    // Start fallback timer for 3 seconds
    fallbackTimer = Timer(const Duration(seconds: 3), () {
      logger.i("API did not respond within 3 seconds, redirecting...");

      if((fallbackTimer?.isActive) ?? false){
        redirectScreen();
        AppConstants.s3Model = S3Model.fromJson({
          "key": "AKIAWQEFG5RG2KSLSHWJ",
          "secret": "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",
          "bucket": "c2c-developments",
          "region": "ap-south-1",
          "url": "https://c2c-developments.s3.ap-south-1.amazonaws.com"
        });
        AppConstants.googleMapKey = "AIzaSyAXARoSGDVeZxn1AFVRS_8-gR9R0j56gD8";
        AppConstants.dealExpireMinutes = 360;
        AppConstants.pdfURL = "https://dev.c2c.sa/secure-file/sign.pdf";
        AppConstants.sellerNafathSignatureUrl = "https://dev.c2c.sa/secure-file/seller-sign.pdf";

      }


    });

    state = SplashState(animationEnd: animationEnd);
    if (ref.watch(getConnectivityProvider).value != null &&
        (ref.watch(getConnectivityProvider).value ?? false)) {
      Future.delayed(Duration(milliseconds: 100)).then((onValue){
        callInitAPI();
      });
    }
    return state;
  }

  @override
  void dispose() {
    fallbackTimer?.cancel();
  }


  Future<void> callInitAPI() async {
    try {


      final response = await remoteRepository!.init();
      // ✅ If API call succeeds, cancel the fallback timer
      fallbackTimer?.cancel();
      fallbackTimer = null;
      if(response.jsonData != null){
        InitModel initModel = InitModel.fromJson(response.jsonData);

        AppConstants.s3Model = initModel.s3;
        AppConstants.googleMapKey = initModel.googleMapKey ?? '';
        AppConstants.inspectFee = initModel.inspectFee ?? 0;
        AppConstants.dealExpireMinutes = initModel.dealExpireMinutes ?? 0;
        AppConstants.pdfURL = initModel.nafathSignatureUrl;
        AppConstants.sellerNafathSignatureUrl = initModel.sellerNafathSignatureUrl;

        print("AppConstants.pdfURL ${AppConstants.pdfURL}");
        print("${initModel.sellerNafathSignatureUrl} AppConstants.sellerNafathSignatureUrl ${AppConstants.sellerNafathSignatureUrl}");

        _handleAppStatus(
          appStatus: initModel.appStatus,
          message: response.message,
        );

        if(initModel.appStatus == AppStatus.forceUpdate || initModel.appStatus == AppStatus.maintenance){
          print("state.copyWith(path: '',screenState: ScreenState.initial,animationEnd: false)");
          state = state.copyWith(path: '',screenState: ScreenState.initial,animationEnd: false);
        }

      }else{
        redirectScreen();
      }



    } catch (e) {
      logger.e("callInitApi: $e");
      redirectScreen();
      //
    }
  }

  void animationEndMethod(bool value){
    state = state.copyWith(animationEnd: value);
    animationEnd = true;
  }

  Future<void> redirectScreen() async {
    bool showOnboard =
        await localRepository?.getData(StorageConstants.onBoard) ?? false;
    bool showLanguageScreen =
        await localRepository?.getData(StorageConstants.languageOpen) ?? false;


    // 👇 Check if a deep link was set
    final uri = ref.read(deepLinkUriProvider);
    if (uri != null) {
      // 👇 Deep link routing logic here
      if (uri.pathSegments.isNotEmpty) {
        // Add more routes based on deep link
        print("URLLLL FROM DEEPLINK SPLASH $uri");
      }
    }
    String path;
 /*   if (userModel?.id != null) {
      if (userModel?.name?.isNotEmpty ?? false) {
        path = Routes.homeStreetDeals;
      } else {
        path = Routes.personalDetails;
      }
    } else {
      path = Routes.languageSelection;
    }*/
    path = AppRoute.personalDetails.path;

    // if (!showLanguageScreen) {
    //   path = Routes.languageSelection;
    // } else if(!showOnboard) {
    //   path = Routes.onboarding;
    // } else {
    //   if(userModel?.isProfileComplete ?? false){
    //     path = Routes.homeStreetDeals;
    //   }else{
    //     path = Routes.registerAccount;
    //   }
    // }

    state = state.copyWith(path: path, screenState: ScreenState.done);
  }

  /// Handles pending notifications
  Future<void> handlePendingNotification() async {
    print(
      'AppConstants.pendingNotificationData -- ${AppConstants.pendingNotificationData} ${AppConstants.deepLinkUrl}',
    );
    if (AppConstants.pendingNotificationData != null) {
      final data = AppConstants.pendingNotificationData;
      AppConstants.pendingNotificationData = null; // Clear after handling

      MyNotificationManager notificationService = MyNotificationManager();

      if (data != null && data.isNotEmpty) {
        switch (notificationService.notificationType) {
          case null:
            // TODO: Handle this case.
            throw UnimplementedError();
          case NotificationType.idVerified:
            // TODO: Handle this case.
            throw UnimplementedError();
          case NotificationType.unknown:
            // TODO: Handle this case.
            throw UnimplementedError();
         }
      }
    } else if (AppConstants.deepLinkUrl != null) {
      _handleDeepLink();
    }else {
      // AppConstants.globalKey.currentContext?.popAllAndPush(
      //   Routes.homeStreetDeals,
      // );
    }
  }

  Future<void> _handleAppStatus({
    required AppStatus appStatus,
    required String message,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final androidAppID = packageInfo.packageName;
    const iosAppID = AppConstants.iosAppStoreId;

    switch (appStatus) {
      case AppStatus.optionalUpdate:
        _showUpdateDialog(
          message: message,
          appName: AppConstants.globalKey.currentContext!.translate.app_name,
          forceUpdate: false,
          androidAppID: androidAppID,
          iosAppID: iosAppID,
        );
        break;

      case AppStatus.forceUpdate:
        _showUpdateDialog(
          message: message,
          appName: AppConstants.globalKey.currentContext!.translate.app_name,
          forceUpdate: true,
          androidAppID: androidAppID,
          iosAppID: iosAppID,
        );
        break;

      case AppStatus.maintenance:
        _showMaintenanceDialog(message: message, appName: AppConstants.globalKey.currentContext!.translate.app_name);
        break;

      case AppStatus.normal:
        redirectScreen();
        break;
    }
  }

  void _showUpdateDialog({
    required String message,
    required String appName,
    required bool forceUpdate,
    required String androidAppID,
    required String iosAppID,
  }) {
    AppDialog.showAdaptiveAppDialog(
      titleStr: appName,
      message: message,
      positiveText:AppConstants.globalKey.currentContext!.translate.upgrade,
      onPositiveTap: () {
        StoreRedirect.redirect(androidAppId: androidAppID, iOSAppId: iosAppID);
      },
      onNegativeTap: () {
        redirectScreen(); // skip update
      },
      negativeText: forceUpdate ? null : AppConstants.globalKey.currentContext!.translate.later,
      context: AppConstants.globalKey.currentContext!,
    );
  }

  void _showMaintenanceDialog({
    required String message,
    required String appName,
  }) {
    AppDialog.showAdaptiveAppDialog(
      context: AppConstants.globalKey.currentContext!,
      titleStr: appName,
      message: message,
      positiveText: AppConstants.globalKey.currentContext!.translate.okay,
      onPositiveTap: () {
        Platform.isAndroid ? SystemNavigator.pop() : null;
      },
    );
  }


  /// Handles deeplink
  Future<void> _handleDeepLink() async {
    print(
      'AppConstants.deepLinkUrl -- ${AppConstants.deepLinkUrl}',
    );
    if (AppConstants.deepLinkUrl != null) {

      final data = AppConstants.deepLinkUrl;
      AppConstants.deepLinkUrl = null; // Clear after handling
      print(
        'AppConstants.data -- ${data}',
      );
      if (data != null && data.isNotEmpty) {
        CommonMethods.getRouteFromDynamicLinks(Uri.parse(data), AppConstants.globalKey.currentContext!);
      }
    } else {
      // AppConstants.globalKey.currentContext?.popAllAndPush(
      //   Routes.homeStreetDeals,
      // );
    }
  }

  Future<void> _removeBadge() async {
    if (await FlutterAppBadgeControl.isAppBadgeSupported()) {
      FlutterAppBadgeControl.removeBadge();
    }
  }
}
