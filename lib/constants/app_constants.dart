
import 'package:c2c/enums/sort_by.dart';
import 'package:c2c/enums/user_type.dart';
import 'package:c2c/l10n/localization.dart';

import 'package:c2c/widget/drop_down/dropdown_model.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../enums/language_code.dart';
import '../gen/assets.gen.dart';
import '../services/google_place/google_place_model.dart';
import '../src/domain/model/init_model/init_model.dart';


class AppConstants {

  static String appName = "C2C";
  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  static String googleMapKey = "";
  static num inspectFee = 0;
  static const iosAppStoreId = '6746741974';
  // static String googleMapKey = "AIzaSyCdRMa0udvixtc5FFKXUq2uDWgoRf9e2po";


  static LanguageCode defaultLocale = LanguageCode.en;
  static ThemeMode defaultTheme = ThemeMode.dark;
  static LanguageCode currentLocale = defaultLocale;
  static UserType currentUserType = UserType.seller;
  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;
  static TextDirection ltrDirection = TextDirection.ltr;


  static LatLng currentLatLng = const LatLng(0, 0);

  static GooglePlaceModel? userLocation;
  static Map<String, dynamic>? pendingNotificationData;
  static String? deepLinkUrl;


  static String firebaseToken = "1234";

  static String versionNo = "${globalKey.currentContext!.translate.version} 1.0.0 (6)";

  static double kButtonHeight = 48;


  static String? pdfURL;
  static String? sellerNafathSignatureUrl;
  static S3Model? s3Model;
  static int dealExpireMinutes = 0;

  static bool isLoggedIn = false;
  static bool? isNetworkConnected = false;
  static bool isOtpVerified = false;
  static ValueNotifier<bool> showNotificationDot = ValueNotifier(false);
  static String currentUTCDate = "";



  static List<DropdownModel> dummyDropDownList = [
    DropdownModel(id: 1, label: SortBy.asABuyer.value),
    DropdownModel(id: 2, label: SortBy.asASeller.value),
  ];

  static List<String> dummyStringList = [
   '1_label','2_label','3_label','4_label','5_label','6_label','7_label','8_label'
  ];
}
