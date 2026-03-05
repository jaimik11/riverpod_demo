import 'dart:convert';

import 'package:c2c/constants/api_constants.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/router/navigation_methods.dart';
import 'package:c2c/services/api_service/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../constants/app_constants.dart';
import '../../constants/storage_constants.dart';
import '../../di/app_providers.dart';
import '../../router/route_observer.dart';
import '../../utils/common_methods.dart';
import '../../utils/logger_util.dart';


class ApiInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!(AppConstants.isNetworkConnected ?? false)) {
    // if (!await CommonMethods.checkConnectivity()) {
      final customResponse = {
        'status': false,
        'message': AppConstants.globalKey.currentContext!.translate.noInternetMsg,
      };
      return handler.resolve(
        Response(
          requestOptions: options,
          data: customResponse,
          statusCode: 200,
        ),
      );
    }

    final method = options.method;
    final uri = options.uri;
    final data = options.data;

    ProviderContainer ref = ProviderContainer();

    String? token = await ref.read(localRepositoryProvider).getData(StorageConstants.token);
    String? lang = await ref.read(localRepositoryProvider).getData(StorageConstants.locale);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }



   options.headers['Accept'] = 'application/json';
   options.headers['Accept-Language'] = lang ?? AppConstants.currentLocale.name;
   options.headers['KEY'] = 'C2C@123*';

    if (method == 'GET') {
      logger.log(
        '✈️ REQUEST[$method] => PATH: $uri \n Token: ${options.headers}',
        printFullText: true,
      );
    } else {
      try {
        logger.log(
          '✈️ REQUEST[$method] => PATH: $uri \n Token:${options.headers} \n DATA: ${jsonEncode(data)}',
          printFullText: true,
        );
      } catch (e) {
        // If jsonEncode fails (usually for FormData), print manually
        if (data is FormData) {
          final buffer = StringBuffer();
          buffer.writeln('✈️ REQUEST[$method] => PATH: $uri');
          buffer.writeln('Token: ${options.headers}');
          buffer.writeln('FormData fields:');

          for (final field in data.fields) {
            buffer.write('  ${field.key}: ${field.value} ');
          }

          buffer.writeln('FormData files:');
          for (final file in data.files) {
            buffer.writeln(
              '  ${file.key}: filename=${file.value.filename} contentType=${file.value.contentType} ',
            );
          }

          logger.log(buffer.toString(), printFullText: true);
        } else {
          logger.log(
            '✈️ REQUEST[$method] => PATH: $uri\n'
                'Token: ${options.headers}\n'
                'DATA: $data',
            printFullText: true,
          );
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final statusCode = response.statusCode;
    final uri = response.requestOptions.uri;
    final data = jsonEncode(response.data);

    logger.log(
      '✅ RESPONSE[$statusCode] => PATH: $uri\n DATA: ${data} \n',
      printFullText: true,
    );

    if (response.requestOptions.uri.toString().contains(ApiConstants.myDeals)) {

      final dateHeader = response.headers.value('date');
      AppConstants.currentUTCDate = dateHeader ?? '';
    }

    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final statusCode = err.response?.statusCode;
    final uri = err.requestOptions.uri;
    final responseData = err.response?.data;
    final context = AppConstants.globalKey.currentContext;

    String? message = context?.translate.smgWentWrong;



    // Handle DioError types (network-related)
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      message = context?.translate.requestTimeOut;
      return handler.resolve(
        Response(
          data: {
            'status': false,
            'message': message,
          },
          statusCode: 408,
          requestOptions: err.requestOptions,
        ),
      );
    }

    if (err.type == DioExceptionType.badCertificate) {
      message = 'SSL certificate issue detected.';
    }
    else if (err.type == DioExceptionType.badResponse) {
      // Handle HTTP errors
      switch (statusCode) {
        case 400:
          message = _extractMessage(responseData, defaultMsg: 'Bad Request');
          break;
        case 401:
        case 403:
          message = context?.translate.apiLogoutMsg ?? 'Session expired';
          final currentRoute = RouteLoggingObserver.currentRoute;
          // if (currentRoute != Routes.registerAccount) {
          //   ProviderContainer().read(localRepositoryProvider).clearData();
          //   context?.popAllAndPush(Routes.registerAccount);
          // }
          return handler.resolve(
            Response(
              data: {'status': false, 'message': message},
              statusCode: statusCode,
              requestOptions: err.requestOptions,
            ),
          );
        case 404:
          message = 'The requested resource was not found.';
          break;
        case 422:
          message = _extractMessage(responseData, defaultMsg: 'Validation failed');
          break;
        case 429:
          message = 'Too many requests. Please slow down.';
          break;
        case 500:
          message = 'Internal server error.';
          break;
        case 502:
          message = 'Bad Gateway.';
          break;
        case 503:
          message = 'Service unavailable.';
          break;
        case 504:
          message = 'Gateway timeout.';
          break;
        default:
          message = _extractMessage(responseData, defaultMsg: message ?? "");
      }
    } else if (err.type == DioExceptionType.cancel) {
      message = 'Request was cancelled.';
    } else if (err.type == DioExceptionType.unknown) {
      message = '';
    }
    // Log error
    logger.log(
      '⚠️ ERROR[${statusCode ?? 'No Status'}] => PATH: $uri\n DATA: $responseData HEADERS ${err.response?.headers}',
      printFullText: true,
    );
    return handler.resolve(
      Response(
        data: {
          'status': false,
          'message': message,
        },
        statusCode: statusCode ?? 500,
        requestOptions: err.requestOptions,
      ),
    );
  }

  String _extractMessage(dynamic responseData, {required String defaultMsg}) {
    try {
      if (responseData is Map) {
        if (responseData.containsKey('message')) {
          return responseData['message'].toString();
        } else if (responseData.containsKey('error')) {
          return responseData['error'].toString();
        } else if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            } else {
              return firstError.toString();
            }
          }
        }
      }
    } catch (_) {}
    return defaultMsg;
  }

}
