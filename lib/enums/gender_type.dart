import 'package:c2c/l10n/localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/app_constants.dart';

enum GenderType {
  @JsonValue("male")
  male,
  @JsonValue("female")
  female,
  @JsonValue("other")
  other,
}

extension GenderTypeExtension on GenderType {
  String get value {
    switch (this) {
      case GenderType.male:
        return AppConstants.globalKey.currentState!.context.translate.male;
      case GenderType.female:
        return AppConstants.globalKey.currentState!.context.translate.female;
      case GenderType.other:
        return AppConstants.globalKey.currentState!.context.translate.other;
    }
  }


}