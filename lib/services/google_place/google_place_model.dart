  class GooglePlaceModel {
    double lat;
    double lng;
    String formattedAddress;
    String shortAddressName;
    String locationAddressFull;
    String countryName;
    String cityName;
    String stateName;
    String postalCode;

    @override
    String toString() {
      return 'GooglePlaceModel{lat: $lat, lng: $lng, formattedAddress: $formattedAddress, shortAddressName: $shortAddressName, locationAddressFull: $locationAddressFull, countryName: $countryName, cityName: $cityName, stateName: $stateName, postalCode: $postalCode}';
    }

    GooglePlaceModel({
      this.lat = 0.0,
      this.lng = 0.0,
      this.formattedAddress = '',
      this.shortAddressName = '',
      this.locationAddressFull = '',
      this.countryName = '',
      this.cityName = '',
      this.stateName = '',
      this.postalCode = '',
    });

    factory GooglePlaceModel.fromJson(Map<String, dynamic> json) {
      return GooglePlaceModel(
        lat: (json['lat'] ?? 0.0).toDouble(),
        lng: (json['lng'] ?? 0.0).toDouble(),
        formattedAddress: json['formattedAddress'] ?? '',
        shortAddressName: json['shortAddressName'] ?? '',
        locationAddressFull: json['locationAddressFull'] ?? '',
        countryName: json['countryName'] ?? '',
        cityName: json['cityName'] ?? '',
        stateName: json['stateName'] ?? '',
        postalCode: json['postalCode'] ?? '',
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'lat': lat,
        'lng': lng,
        'formattedAddress': formattedAddress,
        'shortAddressName': shortAddressName,
        'locationAddressFull': locationAddressFull,
        'countryName': countryName,
        'cityName': cityName,
        'stateName': stateName,
        'postalCode': postalCode,
      };
    }

    GooglePlaceModel copyWith({
      double? lat,
      double? lng,
      String? formattedAddress,
      String? shortAddressName,
      String? locationAddressFull,
      String? countryName,
      String? cityName,
      String? stateName,
      String? postalCode,
    }) {
      return GooglePlaceModel(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        formattedAddress: formattedAddress ?? this.formattedAddress,
        shortAddressName: shortAddressName ?? this.shortAddressName,
        locationAddressFull: locationAddressFull ?? this.locationAddressFull,
        countryName: countryName ?? this.countryName,
        cityName: cityName ?? this.cityName,
        stateName: stateName ?? this.stateName,
        postalCode: postalCode ?? this.postalCode,
      );
    }
  }

  class LatLong {
    final double latitude;
    final double longitude;

    LatLong({required this.latitude, required this.longitude});
  }
