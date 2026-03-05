
import 'package:c2c/l10n/localization.dart';

import '../constants/app_constants.dart';
import 'language_code.dart';

enum JoinUsTab {
  angelInvestor,
  talentTeam,
}

extension JoinUsTabeExtension on JoinUsTab {
  String get value {
    switch (this) {
      case JoinUsTab.angelInvestor:
        return AppConstants.globalKey!.currentState!.context.translate.angelInvestor;
      case JoinUsTab.talentTeam:
        return AppConstants.globalKey!.currentState!.context.translate.talentTeam;
    }
  }
}