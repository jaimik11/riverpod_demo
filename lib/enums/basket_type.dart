
import '../constants/app_constants.dart';
import 'language_code.dart';

enum BasketType {
  generalBasket,
  privateBasket,
}

extension BasketTypeExtension on BasketType {
  String get value {
    switch (this) {
      case BasketType.generalBasket:
        return AppConstants.currentLocale == LanguageCode.en ? "General Basket" : "arabic";
      case BasketType.privateBasket:
        return AppConstants.currentLocale == LanguageCode.en ?"Private Basket" : "arabic";
    }
  }
}