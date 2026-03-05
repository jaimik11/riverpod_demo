import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/src/domain/model/init_model/init_model.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/logger_util.dart';

class AwsS3Service {
  static final Dio _dio = Dio();

  /// Upload file to s3 bucket using Dio
  static Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
    Function(int sent, int total)? onProgress,
  }) async {
    final length = fileBytes.length;

    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
    };

    final policy = Policy.fromS3PresignedPost(
      '${S3Model.s3BucketSlug}/$folderName/$fileName',
      AppConstants.s3Model!.bucketName!,
      AppConstants.s3Model!.accessKey!,
      15,
      length,
      AppConstants.s3Model!.region!,
    );

    final key = SigV4.calculateSigningKey(
      AppConstants.s3Model!.secretKey!,
      policy.datetime,
      AppConstants.s3Model!.region!,
      's3',
    );
    final signature = SigV4.calculateSignature(key, policy.encode());

    // Create FormData for the multipart request
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      'key': policy.key,
      'X-Amz-Credential': policy.credential,
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Date': policy.datetime,
      'Policy': policy.encode(),
      'X-Amz-Signature': signature,
    });

    try {
      final response = await _dio.post(
        AppConstants.s3Model!.url!,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: onProgress,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return "${AppConstants.s3Model!.url!}/${S3Model.s3BucketSlug}/$folderName/$fileName";
      }
      return '';
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}, Response: ${e.response?.data}");
      return '';
    } catch (e) {
      logger.e("Error uploading file: $e");
      return '';
    }
  }

  /// Delete file from s3 bucket using Dio
  static Future<bool> deleteFile({
    required String folderName,
    required String fileName,
  }) async {
    final url =
        '${AppConstants.s3Model!.url}/${S3Model.s3BucketSlug}/$folderName/$fileName';
    final datetime = SigV4.generateDatetime();
    final contentSha256 = sha256
        .convert(utf8.encode(''))
        .toString(); // Empty body for DELETE request

    final headers = {
      'x-amz-date': datetime,
      'Host':
          '${AppConstants.s3Model!.bucketName}.s3.${AppConstants.s3Model!.region}.amazonaws.com',
      'x-amz-content-sha256': contentSha256,
    };

    final signature = _calculateDeleteSignature(
      fileName,
      folderName,
      datetime,
      contentSha256,
    );

    headers['Authorization'] = signature;

    try {
      final response =
          await _dio.delete(url, options: Options(headers: headers));
      if (response.statusCode == 204) {
        // File deleted successfully
        return true;
      } else {
        logger.e('Failed to delete file: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.e('Error deleting file: $e');
      return false;
    }
  }

  /// Create signature for deleting the file from S3
  static String _calculateDeleteSignature(
    String fileName,
    String folderName,
    String datetime,
    String contentSha256,
  ) {
    final region = AppConstants.s3Model!.region;
    const service = 's3';

    // Create the canonical request
    final canonicalRequest = [
      'DELETE',
      '/${S3Model.s3BucketSlug}/$folderName/$fileName',
      '', // No query parameters
      'host:${AppConstants.s3Model!.bucketName}.s3.$region.amazonaws.com\n'
          'x-amz-content-sha256:$contentSha256\n'
          'x-amz-date:$datetime\n',
      'host;x-amz-content-sha256;x-amz-date',
      contentSha256,
    ].join('\n');

    // Hash the canonical request
    final hashedCanonicalRequest =
        sha256.convert(utf8.encode(canonicalRequest)).toString();

    // Create the string to sign
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      datetime,
      '${datetime.substring(0, 8)}/$region/$service/aws4_request',
      hashedCanonicalRequest,
    ].join('\n');

    // Generate the signing key
    final signingKey = SigV4.calculateSigningKey(
      AppConstants.s3Model!.secretKey!,
      datetime,
      region!,
      service,
    );

    // Calculate the signature
    final signature =
        Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

    return 'AWS4-HMAC-SHA256 Credential=${AppConstants.s3Model!.accessKey}/${datetime.substring(0, 8)}/$region/$service/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=$signature';
  }
}

class Policy {
  String expiration;
  String region;
  String bucket;
  String key;
  String credential;
  String datetime;
  int maxFileSize;

  Policy(
    this.key,
    this.bucket,
    this.datetime,
    this.expiration,
    this.credential,
    this.maxFileSize,
    this.region,
  );

  factory Policy.fromS3PresignedPost(
    String key,
    String bucket,
    String accessKeyId,
    int expiryMinutes,
    int maxFileSize,
    String region,
  ) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';
    final p =
        Policy(key, bucket, datetime, expiration, cred, maxFileSize, region);
    return p;
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "$expiration",
  "conditions": [
    {"bucket": "$bucket"},
    ["starts-with", "\$key", "$key"],
    ["content-length-range", 1, $maxFileSize],
    {"x-amz-credential": "$credential"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "$datetime" }
  ]
}
''';
  }
}
