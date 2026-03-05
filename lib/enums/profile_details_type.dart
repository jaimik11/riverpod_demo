import 'package:c2c/constants/api_constants.dart';
import 'package:c2c/enums/language_code.dart';
import 'package:c2c/l10n/localization.dart';

import '../constants/app_constants.dart';

enum ProfileDetailsType {
  createProfile,
  editProfile
}

extension ProfileDetailsTypeExtension on ProfileDetailsType {
  String get value {
    switch (this) {
      case ProfileDetailsType.createProfile:
        return AppConstants.globalKey.currentState!.context.translate.personalInfo;
      case ProfileDetailsType.editProfile:
        return AppConstants.globalKey.currentState!.context.translate.editProfile;
    }
  }
}