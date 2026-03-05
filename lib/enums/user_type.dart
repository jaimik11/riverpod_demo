import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/enums/language_code.dart';
import 'package:c2c/l10n/localization.dart';

enum UserType {
  guest,
  buyer,
  seller,
  inspector
}

extension GetOfferTabByUserType on UserType {
  String get value {
    switch (this) {
      case UserType.buyer:
        return AppConstants.globalKey.currentState!.context.translate.buyer;
      case UserType.seller:
        return AppConstants.globalKey.currentState!.context.translate.seller;
      case UserType.guest:
        // TODO: Handle this case.
        throw UnimplementedError();
      case UserType.inspector:
        return AppConstants.globalKey.currentState!.context.translate.inspector;
    }
  }
}