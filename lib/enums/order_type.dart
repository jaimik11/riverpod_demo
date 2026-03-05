
import '../constants/app_constants.dart';
import 'language_code.dart';

enum OrderType{
  inspectionOrder,
  driverRequest,
}
extension OrderTypeExtension on OrderType {
  String get value {
    switch (this) {
      case OrderType.inspectionOrder:
        return AppConstants.currentLocale == LanguageCode.en ? "Inspection Orders" : "arabic";
      case OrderType.driverRequest:
        return AppConstants.currentLocale == LanguageCode.en ?"Driver Requests" : "arabic";
    }
  }
}