import 'package:c2c/constants/api_constants.dart';
import 'package:c2c/enums/language_code.dart';

import '../constants/app_constants.dart';

enum MenuItems {
  share,
  reportProduct,
  edit,
  delete,
  moveToRedWeek,
  hide,
  chat,
  makeOffer,
}

extension MenuItemsExtension on MenuItems {
  String get value {
    switch (this) {
      case MenuItems.share:
        return AppConstants.currentLocale == LanguageCode.en ? "Share" : "arabic";
      case MenuItems.reportProduct:
        return AppConstants.currentLocale == LanguageCode.en ?"Report Product" : "arabic";
      case MenuItems.edit:
        return AppConstants.currentLocale == LanguageCode.en ? "Edit" : "arabic";
      case MenuItems.delete:
        return AppConstants.currentLocale == LanguageCode.en ? "Delete" : "arabic";
      case MenuItems.moveToRedWeek:
        return AppConstants.currentLocale == LanguageCode.en ? "Move to Red Week" : "arabic";
      case MenuItems.hide:
        return AppConstants.currentLocale == LanguageCode.en ? "Hide" : "arabic";
      case MenuItems.chat:
        return AppConstants.currentLocale == LanguageCode.en ? "Chat" : "arabic";
      case MenuItems.makeOffer:
        return AppConstants.currentLocale == LanguageCode.en ? "Make Offer" : "arabic";
    }
  }
}