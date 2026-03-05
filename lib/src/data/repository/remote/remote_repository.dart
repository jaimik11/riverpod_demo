import 'dart:io';

import 'package:c2c/enums/upload_type.dart';
import 'package:c2c/enums/user_type.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';


import '../../../../services/api_service/api_response.dart';

abstract class RemoteRepository{

  Future<ApiResponse> init();
}