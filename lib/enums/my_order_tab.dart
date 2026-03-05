
import '../constants/app_constants.dart';
import 'language_code.dart';

enum MyOrderTab{
  myService,
  myTrade,
}
extension MyOrderTabExtension on MyOrderTab {
  String get value {
    switch (this) {
      case MyOrderTab.myTrade:
        return AppConstants.currentLocale == LanguageCode.en ? "My Trade" : "arabic";
      case MyOrderTab.myService:
        return AppConstants.currentLocale == LanguageCode.en ?"My Service" : "arabic";
    }
  }
}