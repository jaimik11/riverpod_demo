import 'dart:io';

import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/utils/loader_util/loading_dialog.dart';
import 'package:c2c/widget/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/logger_util.dart';
import 'google_place/google_place_model.dart';
import 'google_place/google_place_service.dart';

class LocationServiceHelper {
  /// check location service and permission
  static Future<bool> checkLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      _openLocationSettingDialog();
      return false;
    }

    bool isPermissionGranted = await _askLocationPermission(
      whichPermission:  AppConstants.globalKey.currentContext!.translate.location,
    );
    logger.i('LOCATION PERMISSION: $isPermissionGranted');
    return isPermissionGranted;
  }

  /// get current address: lat, lng -- [Set as const global lat lng]
  static Future<void> getCurrentAddress() async {
    try {
      AppConstants.globalKey.currentContext!.loading.show(feedback: AppConstants.globalKey.currentContext!.translate.fetchingAddress);

      Position loc = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

      logger.i("CURRENT LOCATION FETCHED");

      AppConstants.userLocation = await GooglePlaceService.getPlaceDetails(
        latLng: LatLong(latitude: loc.latitude, longitude: loc.longitude),
      );

      AppConstants.currentLatLng = LatLng(AppConstants.userLocation?.lat ?? 0,AppConstants.userLocation?.lng ?? 0);

      logger.i(
        "Global.userLocation.value:${AppConstants.userLocation.toString()}\n\n"
        "Globale location : ${AppConstants.currentLatLng}",
      );

      AppConstants.globalKey.currentContext!.loading.hide();
    } catch (e) {
      logger.e('EXCEPTION getCurrentAddress: ${e.toString()}');
      AppConstants.globalKey.currentContext!.loading.hide();
    }
  }

  /// ask location permission
  static Future<bool> _askLocationPermission({String? whichPermission}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool isPermissionGranted =
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;

    if (isPermissionGranted) {
      return true;
    } else {
      LocationPermission permissionStatus =
      await Geolocator.requestPermission();
      logger.log('STATUS == $permissionStatus');
      if (permissionStatus == LocationPermission.deniedForever) {
        AppDialog.showAdaptiveAppDialog(
          context: AppConstants.globalKey.currentContext!,
          titleStr: AppConstants.globalKey.currentContext!.translate.permission,
          message:
          '${AppConstants.globalKey.currentContext!.translate.pleaseAllowThe} $whichPermission ${AppConstants.globalKey.currentContext!.translate.permissionFromSettings}',
          positiveText: AppConstants.globalKey.currentContext!.translate.settings,
          onPositiveTap: () {
            openAppSettings();
          },
          negativeText: AppConstants.globalKey.currentContext!.translate.cancel,
          onNegativeTap: () {
          },
        );
        return false;
      }
      if (permissionStatus == LocationPermission.always ||
          permissionStatus == LocationPermission.whileInUse) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// location service dialog
  static void _openLocationSettingDialog() {
    Widget title = Text(AppConstants.globalKey.currentContext!.translate.locationIsDisabled);

    Widget contentAndroid = Text(AppConstants.globalKey.currentContext!.translate.pleaseEnableLocation);

    Widget contentIOS = Text(AppConstants.globalKey.currentContext!.translate.enableLocationMessageIOS);

    final actionsAndroid = <Widget>[
      TextButton(
        onPressed: () => AppConstants.globalKey.currentContext!.pop(),
        child: Text(AppConstants.globalKey.currentContext!.translate.noThanks),
      ),
      TextButton(
        onPressed: () async {
          Geolocator.openLocationSettings().then(
                (_) => Navigator.pop(AppConstants.globalKey.currentContext!),
          );
        },
        child: Text(AppConstants.globalKey.currentContext!.translate.okay),
      ),
    ];

    final actionsIOS = <Widget>[
      TextButton(
        onPressed: () => AppConstants.globalKey.currentContext!.pop(),
        child: Text(AppConstants.globalKey.currentContext!.translate.cancel),
      ),
      TextButton(
        onPressed: () async {
          Geolocator.openLocationSettings().then(
                (_) => Navigator.pop(AppConstants.globalKey.currentContext!),
          );
        },
        child: Text(AppConstants.globalKey.currentContext!.translate.settings),
      ),
    ];
    Future.delayed(const Duration(milliseconds: 200), () {
      showDialog(
        context: AppConstants.globalKey.currentContext!,
        builder: (dialogContext) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: title,
            content: contentIOS,
            actions: actionsIOS,
          )
              : Theme(
            data: ThemeData(useMaterial3: false),
            child: AlertDialog(
              title: contentAndroid,
              actions: actionsAndroid,
            ),
          );
        },
      );
    });
  }

  ///
  static Future<bool> checkLocationPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool isPermissionGranted =
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;

    return isPermissionGranted;
  }

}
