import 'dart:convert';
import 'dart:io';

import 'package:c2c/enums/user_type.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../constants/api_constants.dart';
import 'api_interceptor.dart';
import 'api_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.basURL)
abstract class ApiServices {

  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  // /// API Declaration
  @GET('${ApiConstants.init}/{version}/{app_name}')
  Future<ApiResponse> initApi({
    @Path('version') String? version,
    @Path('app_name') String? appName,
  });

}
