import 'package:c2c/l10n/localization.dart';

import '../constants/app_constants.dart';

enum UploadType {
  product,
  order,
}

enum UploadTypeByUser {
  buyer,
  seller,
  inspector,
}

extension UploadTypeByUserExtension on UploadTypeByUser {
  String get value {
    switch (this) {
      case UploadTypeByUser.buyer:
        return AppConstants.globalKey.currentState!.context.translate.buyer;
      case UploadTypeByUser.seller:
        return AppConstants.globalKey.currentState!.context.translate.seller;
      case UploadTypeByUser.inspector:
        return AppConstants.globalKey.currentState!.context.translate.inspector;
    }
  }
}