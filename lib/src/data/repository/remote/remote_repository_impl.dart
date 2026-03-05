import 'dart:io';

import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/enums/upload_type.dart';
import 'package:c2c/enums/user_type.dart';
import 'package:c2c/src/data/repository/remote/remote_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/api_service/api_response.dart';
import '../../../../services/api_service/api_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteRepositoryImpl extends RemoteRepository {
  final ApiServices apiServices;

  RemoteRepositoryImpl({required this.apiServices});

  @override
  Future<ApiResponse> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String device = Platform.isAndroid ? "android" : "ios";

    var d = await apiServices.initApi(
      version: packageInfo.version,
      appName: device,
    );

    return d;
  }

}
