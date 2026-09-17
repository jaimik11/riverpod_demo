import 'dart:async';
import 'dart:io';

import 'package:c2c/l10n/localization.dart';
import 'package:c2c/src/data/repository/remote/remote_repository.dart';
import 'package:c2c/widget/app_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../constants/storage_constants.dart';
import '../../../../../di/app_providers.dart';
import '../../../../../enums/app_status.dart' show AppStatus;
import '../../../../../enums/screen_state.dart';
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
    // Start fallback timer for 3 seconds
    fallbackTimer = Timer(const Duration(seconds: 3), () {
      logger.i("API did not respond within 3 seconds, redirecting...");

      if((fallbackTimer?.isActive) ?? false){
        redirectScreen();
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
        redirectScreen();
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

}
