
import '../constants/app_constants.dart';
import 'language_code.dart';

enum ProfileTab {
  products,
  offer,
  ratings,
  account,
  inspectionOrder,
  shippingPolicies,
  driverRequest,
  deliveryFlights,
}

extension ProfileTabeExtension on ProfileTab {
  String get value {
    switch (this) {
      case ProfileTab.products:
        return AppConstants.currentLocale == LanguageCode.en ? "Products" : "arabic";
      case ProfileTab.offer:
        return AppConstants.currentLocale == LanguageCode.en ?"Offer" : "arabic";
      case ProfileTab.ratings:
        return AppConstants.currentLocale == LanguageCode.en ?"Ratings" : "arabic";
      case ProfileTab.account:
        return AppConstants.currentLocale == LanguageCode.en ?"Account" : "arabic";
      case ProfileTab.inspectionOrder:
        return AppConstants.currentLocale == LanguageCode.en ?"Inspection Order" : "arabic";
      case ProfileTab.shippingPolicies:
        return AppConstants.currentLocale == LanguageCode.en ?"Shipping Policies" : "arabic";
      case ProfileTab.driverRequest:
        return AppConstants.currentLocale == LanguageCode.en ?"Driver Request" : "arabic";
      case ProfileTab.deliveryFlights:
        return AppConstants.currentLocale == LanguageCode.en ?"Delivery Flights" : "arabic";
    }
  }
}