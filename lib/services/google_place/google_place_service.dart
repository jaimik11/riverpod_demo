import 'package:c2c/constants/api_constants.dart';
import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/utils/common_methods.dart';
import 'package:c2c/utils/snackbar_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import '../../utils/logger_util.dart';
import 'google_place_model.dart';

class GooglePlaceService with ChangeNotifier {
  static final _dio = Dio();

  static Future<List> getGooglePlaceSuggestion(
    String query, {
    bool requireFields = true,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    var url = '';
    url = requireFields
        ? '${ApiConstants.mapApiBaseUrl}/place/autocomplete/json?input=$query&fields=place_id,geometry,formatted_address,name&types=establishment&key=${AppConstants.googleMapKey}&sessiontoken=1234567890'
        : '${ApiConstants.mapApiBaseUrl}/place/autocomplete/json?input=$query&key=${AppConstants.googleMapKey}&sessiontoken=1234567890';
    logger.log('URL -- $url');
    final response = await _dio.get(url);
    logger.log('response -- $response');
    List tList = [];
    if (response.data['predictions'].isEmpty) {
      if(query.length > 2){
        showToast(AppConstants.globalKey.currentState!.context.translate.placeNotFound,success: false);
      }
      return [];
    }

    for (int i = 0; i < response.data['predictions'].length; i++) {
      tList.add(response.data['predictions'][i]);
    }

    return tList;
  }

  static Future<GooglePlaceModel> getPlaceDetails({
    String placeId = '',
    LatLong? latLng,
    CancelToken? cancelToken,
  }) async {
    var url = latLng == null
        ? '${ApiConstants.mapApiBaseUrl}/place/details/json?placeid=$placeId&key=${AppConstants.googleMapKey}'
        : '${ApiConstants.mapApiBaseUrl}/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${AppConstants.googleMapKey}';

    print('URL -- $url');

    // if (await CommonMethods.checkConnectivity()) {
    if ((AppConstants.isNetworkConnected ?? false)) {
      final response = await _dio.get(url, cancelToken: cancelToken);

      dynamic responseDataResult;

      GooglePlaceModel? googlePlaceModel;

      if (latLng == null) {
        responseDataResult = response.data['result'];
      } else {
        if ((response.data['results'] as List).isNotEmpty) {
          responseDataResult = (response.data['results'])[0];
        } else {
          return GooglePlaceModel();
        }
      }
   logger.log("responseDataResult $responseDataResult",printFullText: true);
      double latitude = responseDataResult['geometry']['location']['lat'];
      double longitude = responseDataResult['geometry']['location']['lng'];

      String country = '';
      String state = '';
      String city = '';
      String postalCode = '';

      String subLocality = '';
      String locality = '';

      String formattedAddress = responseDataResult['formatted_address'];
      String shortAddressName = (latLng == null
              ? responseDataResult['name']
              : responseDataResult['premise']) ??
          formattedAddress;

      List list = responseDataResult['address_components'];
      if (list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          var data = list[i]['types'];

          // country
          if (data.toString().contains('country')) {
            country = list[i]['long_name'].toString();
          }

          // state
          else if (data.toString().contains('administrative_area_level_1')) {
            state = list[i]['long_name'].toString();
          }

          // city
          else if (data.toString().contains('administrative_area_level_3')) {
            city = list[i]['long_name'].toString();
          } else if (!data.toString().contains('administrative_area_level_3') &&
              data.toString().contains('neighborhood')) {
            city = list[i]['long_name'].toString();
          }

          // sub locality
          else if (data.toString().contains('sublocality_level_1')) {
            subLocality = list[i]['long_name'].toString();
          } else if (!data.toString().contains('sublocality_level_1') &&
              data.toString().contains('route')) {
            subLocality = list[i]['long_name'].toString();
          }

          // locality
          else if (data.toString().contains('locality')) {
            locality = list[i]['long_name'].toString();
          }

          // postal code
          else if (data.toString().contains('postal_code')) {
            postalCode = list[i]['long_name'].toString();
          }
        }
      }

      googlePlaceModel = GooglePlaceModel(
        lat: latitude,
        lng: longitude,
        formattedAddress: formattedAddress,
        shortAddressName: shortAddressName,
        locationAddressFull: '$shortAddressName, $city, $postalCode, $country',
        countryName: country,
        cityName: city.isEmpty ? shortAddressName : city,
        stateName: state,
        postalCode: postalCode,
      );

      return googlePlaceModel;
    } else {
      showToast(AppConstants.globalKey.currentState!.context.translate.noInternetMsg,success: false);
      return GooglePlaceModel();
    }
  }
}
