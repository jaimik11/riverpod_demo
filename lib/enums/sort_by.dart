import 'package:c2c/enums/language_code.dart';
import 'package:c2c/l10n/localization.dart';

import '../constants/app_constants.dart';

enum SortBy {
  asABuyer,
  asASeller,
}

extension BasketTypeExtension on SortBy {
  String get value {
    switch (this) {
      case SortBy.asABuyer:
        return AppConstants.globalKey.currentContext!.translate.asABuyer;
      case SortBy.asASeller:
        return AppConstants.globalKey.currentContext!.translate.asASeller;
    }
  }
}
