import 'package:c2c/constants/api_constants.dart';
import 'package:c2c/enums/language_code.dart';
import 'package:c2c/l10n/localization.dart';

import '../constants/app_constants.dart';
import '../gen/assets.gen.dart';

enum CmsPages {
  aboutUs,
  terms,
  privacyPolicy,
}

extension CmsPagesExtension on CmsPages {
  String get value {
    switch (this) {
      case CmsPages.aboutUs:
        return AppConstants.globalKey.currentState!.context.translate.about;
      case CmsPages.terms:
        return AppConstants.globalKey.currentState!.context.translate.termsOfUse;
      case CmsPages.privacyPolicy:
        return AppConstants.globalKey.currentState!.context.translate.privacyPolicy;
    }
  }

  String get endPoint {
    switch (this) {
      case CmsPages.aboutUs:
        return ApiConstants.aboutUs;
      case CmsPages.terms:
        return ApiConstants.terms;
      case CmsPages.privacyPolicy:
        return ApiConstants.privacyPolicy;
    }
  }
}