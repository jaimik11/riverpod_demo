import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/utils/loader_util/loading_dialog.dart';
import 'package:c2c/utils/snackbar_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picker_pro_max_ultra/media_picker_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../constants/app_fonts.dart';
import '../enums/image_type.dart';
import '../enums/language_code.dart';
import '../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../widget/app_dialog.dart';
import '../widget/image_picker_bottom_sheet.dart';
import '../widget/image_swiper_page.dart';
import 'logger_util.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CommonMethods {
  static const MethodChannel _channel = MethodChannel('video_thumbnail');

  static String nameRegExp = r'^.{2,70}$';

  static const imageExtensions = [".jpg", ".png", ".jpeg", ".heic", ".heif", ".webp"];

  hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<bool> checkConnectivity() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }

  static Future<int> getAndroidVersion() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo =
          await DeviceInfoPlugin().androidInfo;
      logger.log(
        "androidDeviceInfo.version.sdkInt: ${androidDeviceInfo.version.sdkInt}",
      );
      return androidDeviceInfo.version.sdkInt;
    } else {
      return 0;
    }
  }

  ///  Method for getting picked image size
  static Future<bool> imageSize(XFile file) async {
    final bytes = (await file.readAsBytes()).lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    logger.e("IMAGE SIZE ----$mb");

    if (mb <= 25) {
      return true;
    } else {
      return false;
    }
  }

  ///  Method for requesting location permission
  static Future<bool> askPermission({
    Permission? permission,
    String? whichPermission,
  }) async {
    bool isPermissionGranted = await permission!.isGranted;
    var shouldShowRequestRationale =
        await permission.shouldShowRequestRationale;

    if (isPermissionGranted) {
      return true;
    } else {
      if (!shouldShowRequestRationale) {
        var permissionStatus = await permission.request();
        logger.e("STATUS == $permissionStatus");
        if (permissionStatus.isPermanentlyDenied) {
          AppDialog.showAppAlertDialog(
            title: AppConstants
                .globalKey
                .currentState!
                .context
                .translate
                .permission,
            description:
                '${AppConstants.globalKey.currentState!.context.translate.pleaseAllowThe} $whichPermission ${AppConstants.globalKey.currentState!.context.translate.permissionFromSettings}',
            negativeText:
                AppConstants.globalKey.currentState!.context.translate.cancel,
            positiveText:
                AppConstants.globalKey.currentState!.context.translate.settings,
            onPositiveTap: () {
              openAppSettings();
            },
            context: AppConstants.globalKey.currentContext!,
          );
          return false;
        }
        if (permissionStatus.isGranted || permissionStatus.isLimited) {
          return true;
        } else {
          return false;
        }
      } else {
        var permissionStatus = await permission.request();
        if (permissionStatus.isGranted || permissionStatus.isLimited) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  static Future<Permission> getPermission(MediaType mediaType) async {
    if (mediaType == MediaType.video) {
      if (Platform.isAndroid) {
        return Permission.videos;
      } else {
        return Permission.storage;
      }
    } else {
      if (Platform.isAndroid && await CommonMethods.getAndroidVersion() < 33) {
        return Permission.storage;
      } else {
        return Permission.photos;
      }
    }
  }


  static List<String> getSelectedFileNames(List<XFile?> listOfFiles) {
    return listOfFiles
        .whereType<XFile>() // filters out nulls
        .map((xfile) => xfile.path)
        .toList();
  }

  static Container gradientBorder() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.bg, AppColors.hintColor, AppColors.bg],
        ),
      ),
    );
  }

  /// animate camera
  static void animateCameraToLocation({
    required GoogleMapController mapController,
    required LatLng? targetLocation,
    double zoom = 15,
  }) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              targetLocation ??
              AppConstants.currentLatLng ??
              const LatLng(0, 0),
          zoom: targetLocation == null && AppConstants.currentLatLng == null
              ? 1
              : zoom,
        ),
      ),
    );
  }

  static Future<String> getMapStyle() async {
    ThemeData theme = Theme.of(AppConstants.globalKey.currentState!.context);
    bool isDarkMode = theme.brightness == Brightness.dark;
    return isDarkMode
        ? await rootBundle.loadString('assets/map/night.json')
        : await rootBundle.loadString('assets/map/light.json');
  }

  static String getConvertedDate({
    String? inputDateFormat,
    String? outputDateFormat = "MMM dd, yyyy",
    String? date,
  }) {
    if (date == null || date.isEmpty) {
      return "";
    }
    try {
      String locale = AppConstants.currentLocale.name;

      DateTime inputDate = DateFormat(inputDateFormat, 'en').parse(date);
      // Now format it in the current locale for UI display
      String dateFormat = DateFormat(
        outputDateFormat,
        locale,
      ).format(inputDate);
      return dateFormat;
    } catch (exception) {
      String locale = AppConstants.currentLocale.name;
      logger.e("getConvertedDate:$exception $locale");
      return "";
    }
  }

  static Duration getRemainingTimeFromCreatedUTC(String? createdTime,String? expMinutes) {
    try {
      // Parse created time in UTC
      final DateTime createdDateTime = DateFormat(
        "yyyy-MM-dd HH:mm:ss",
      ).parseUtc(createdTime!);

      // Add 6 hours to created time
      final DateTime deadline = createdDateTime.add(
        Duration(minutes: int.tryParse(expMinutes!) ?? AppConstants.dealExpireMinutes),
      );
      final DateTime? nowUtc;

      String getCurrentUTCTime = convertToHttpDate();
      if (getCurrentUTCTime.isNotEmpty) {
        nowUtc = DateFormat(
          "yyyy-MM-dd HH:mm:ss",
        ).parseUtc(getCurrentUTCTime);
      } else {
        nowUtc = DateTime.now().toUtc();
      }

      // Get remaining time
      final Duration remaining = deadline.difference(nowUtc);

      // Return only if it's still within the 6-hour window
      return remaining.isNegative ? Duration.zero : remaining;
    } catch (e) {
      // print("getRemainingTimeFromCreatedUTC error: $e");
      return Duration.zero;
    }
  }

  /// DEPRECATED
  static Duration getRemainingTimeFromUTC(String createdTime,String expTime) {
    try {
      final DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm:ss");

      final DateTime expiryUTC = formatter.parseUtc(expTime);
      final DateTime nowUTC = DateTime.now().toUtc();

      final Duration remaining = expiryUTC.difference(nowUTC);

      return remaining.isNegative ? Duration.zero : remaining;
    } catch (e) {
      print("getRemainingTimeFromUTC error: $e");
      return Duration.zero;
    }
  }

  static String convertToHttpDate() {
    try {
      // Parse the input using the HTTP date format
      final httpFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
      final dateTime = httpFormat.parseUtc(AppConstants.currentUTCDate);

      // Format to "yyyy-MM-dd HH:mm:ss"
      final standardFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      return standardFormat.format(dateTime.toUtc());
    } catch (e, stackTrace) {
      // You can log this error or handle it differently if needed
      return ''; // or return null / fallback value
    }
  }




  static bool isValidFile(String path) {
    final ext = path.toLowerCase().substring(path.lastIndexOf('.'));
    return imageExtensions.contains(ext);
  }

  static void getRouteFromDynamicLinks(Uri uri, BuildContext context) {
    if (uri.pathSegments.isEmpty) return;

    final pathSegments = uri.pathSegments;

    // Check if the first segment is a locale
    final cleanedSegments =
    (pathSegments.isNotEmpty &&
        (pathSegments.first == 'ar' || pathSegments.first == 'en'))
        ? pathSegments.sublist(1)
        : pathSegments;

    // Remove empty segments and any trailing slash artifacts
    final finalCleanedSegments =
    cleanedSegments.where((segment) => segment.trim().isNotEmpty).toList();

    final pathSegmentCount = finalCleanedSegments.length;

    final firstSegment = finalCleanedSegments.first;
    final lastSegment = finalCleanedSegments.last;
    print("firstSegment -- $firstSegment -- lastSegment -- ${lastSegment} -- Count --$pathSegmentCount");

    switch (firstSegment) {
      case 'product':
        // handleProductCodePage(uri, pathSegmentCount, lastSegment);
        break;

      default:
        return;
    }
  }



  static String formatWithSpaceEvery3Digits(String input) {
    return input.replaceAllMapped(RegExp(r".{1,3}"), (match) => "${match.group(0)} ").trim();
  }



  /// Common Cupertino date picker function
  static Future<DateTime?> showCupertinoDatePicker({
    required BuildContext context,
    DateFormat? formatter,
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    void Function(DateTime selectedDate)? onDateChanged,
  }) async {
    DateTime selectedDate = initialDate ?? DateTime.now();
    DateTime? finalDate;

    final DateFormat usedFormatter = formatter ?? DateFormat('dd MMM yyyy');

    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            // Done button
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(context.translate.done),
                onPressed: () {
                  // Normalize date without losing the DateTime type
                  finalDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  );

                  onDateChanged?.call(finalDate!);
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Date picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                minimumDate: minDate,
                maximumDate: maxDate ?? DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  selectedDate = newDate;
                },
              ),
            ),
          ],
        ),
      ),
    );

    return finalDate;
  }





  /// Common Cupertino time picker function
  static Future<TimeOfDay?> showCupertinoTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
    void Function(TimeOfDay selectedTime)? onTimeChanged,
  }) async {
    final now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      initialTime?.hour ?? now.hour,
      initialTime?.minute ?? now.minute,
    );

    DateTime? finalTime;

    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            // Done button
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(context.translate.done),
                onPressed: () {
                  finalTime = selectedDateTime;
                  onTimeChanged?.call(
                    TimeOfDay(hour: finalTime!.hour, minute: finalTime!.minute),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Time picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                initialDateTime: selectedDateTime,
                onDateTimeChanged: (DateTime newDateTime) {
                  selectedDateTime = newDateTime;
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (finalTime != null) {
      return TimeOfDay(hour: finalTime!.hour, minute: finalTime!.minute);
    }

    return null;
  }

  static Future<TimeOfDay?> showCupertinoTimeWithIntervalPicker({
    required BuildContext context,
    TimeOfDay? initialTime,
    void Function(TimeOfDay selectedTime)? onTimeChanged,
    int minuteInterval = 15, // Only allows 0, 15, 30, 45
  }) async {
    final now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      initialTime?.hour ?? now.hour,
      initialTime?.minute ?? now.minute,
    );

    DateTime? finalTime;

    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            // Done button
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(context.translate.done),
                onPressed: () {
                  finalTime = selectedDateTime;
                  onTimeChanged?.call(
                    TimeOfDay(hour: finalTime!.hour, minute: finalTime!.minute),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Time picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                initialDateTime: selectedDateTime,
                onDateTimeChanged: (DateTime newDateTime) {
                  final roundedMinute =
                      ((newDateTime.minute / minuteInterval).round() * minuteInterval) % 60;

                  selectedDateTime = DateTime(
                    newDateTime.year,
                    newDateTime.month,
                    newDateTime.day,
                    newDateTime.hour,
                    roundedMinute,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (finalTime != null) {
      return TimeOfDay(hour: finalTime!.hour, minute: finalTime!.minute);
    }

    return null;
  }

  static List<TimeOfDay> generateTimeSlots() {
    final List<TimeOfDay> slots = [];

    for (int hour = 1; hour < 24; hour++) {
      slots.add(TimeOfDay(hour: hour, minute: 0));
    }
    if(slots.length == 23){
      slots.add(TimeOfDay(hour: 0, minute: 0));
    }

    return slots;
  }

  static int getAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // If birthday hasn’t occurred yet this year, subtract 1
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  static String convertMinutesToHrMinString(String minutesStr) {
    final totalMinutes = int.tryParse(minutesStr) ?? 0;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours == 0 && minutes == 0) {
      return '24hr';
    }

    final hourPart = '${hours}hr';
    final minutePart = minutes > 0 ? ':${minutes.toString().padLeft(2, '0')} mins' : '';

    return '$hourPart$minutePart';
  }

  static void downloadInvoice(String url) async {
    // if (await canLaunchUrl(Uri.parse(url))) {
    downloadPdf(url,getPdfFileName(url));
    await launchUrl(Uri.parse(url));
    // } else {
    //   throw "Could not launch WhatsApp";
    // }
  }


  static Future<String?> downloadPdf(String url, String fileName) async {
    try {
      // Get device storage directory
      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download'); // Public downloads folder
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      // File save path
      String filePath = "${dir.path}/$fileName";

      // Fetch file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        if(filePath.isNotEmpty){
          showToast(AppConstants.globalKey.currentContext!.translate.pdfSaved);
        }
        print("PDF saved to: $filePath");
        return filePath; // You can return the path for later use
      } else {
        print("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading PDF: $e");
    }
    return null;
  }

  static String getPdfFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last;
    if (fileName.toLowerCase().endsWith('.pdf')) {
      return fileName;
    }
    return '';
  }

  static Future<File?> compressFile(File? file) async {
    if (file == null) return null;

    try {
      if (file.path.toLowerCase().endsWith('.mp4')) {
        return file; // Skip compression for video files
      }
      if (file.path.toLowerCase().endsWith('.png')) {
        return file; // Skip compression for video files
      }

      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/compressed_${file.uri.pathSegments.last}';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 75, // Adjust quality as needed
      );


      return compressedFile == null ? file : File(compressedFile.path);
    } catch (e, stackTrace) {
      return file;
    }
  }

  static String convertTo24HourFormat(String time12h) {
    // Parse input like "11:55AM"
    final DateFormat inputFormat = DateFormat("hh:mm a");
    final DateTime dateTime = inputFormat.parse(time12h);

    // Format to "HH:mm:ss"
    final DateFormat outputFormat = DateFormat("HH:mm:ss");
    return outputFormat.format(dateTime);
  }

  static String convertToIsoDate(String date) {
    // Parse input like "16-09-2025"
    final DateFormat inputFormat = DateFormat("dd-MM-yyyy");
    final DateTime dateTime = inputFormat.parse(date);

    // Format to "yyyy-MM-dd"
    final DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    return outputFormat.format(dateTime);
  }

  static Future<File> createFileOfPdfUrl(String path) async {
    Completer<File> completer = Completer();
    try {
      final url = path;
      final filename = url?.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url!));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  static String formatDateLabel(DateTime isoTimestamp) {
    final date = isoTimestamp.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) {
      return AppConstants.globalKey.currentState!.context.translate.today;
    } else if (date.isAfter(yesterday)) {
      return AppConstants.globalKey.currentState!.context.translate.yesterday;
    } else {
      return DateFormat('MMM d').format(date); // e.g., "Dec 10"
    }
  }
}
