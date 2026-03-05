

import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/l10n/localization.dart';

class AppValidator {
  static bool isEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  static String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static String mobileRegex = r'^\d{8,10}$';
  static String passwordRegex =
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$';
  static RegExp allowedNameRegex = RegExp(r"[\u0600-\u06FFa-zA-Z ]");
  static RegExp allowedOnlyDigitsRegex = RegExp(r'^\d+');
  static RegExp allowedIdRegex = RegExp(r'[a-zA-Z0-9]');

  static bool isEmail(String em) {
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(em);
  }

  static bool isMobile(String mobile) {
    RegExp regex = RegExp(mobileRegex);
    return regex.hasMatch(mobile);
  }

  static bool isPassword(String value) {
    RegExp regExp = RegExp(passwordRegex);
    return regExp.hasMatch(value);
  }

  static String? emptyValidator({String? value, required String errorString}) {
    if (value?.trim().isEmpty ?? true) {
      return errorString;
    } else {
      return null;
    }
  }

  // /// name validator
  static String? name({
    required String value,
  }) {
    if (AppValidator.isEmpty(value)) {
      return AppConstants.globalKey.currentState!.context.translate.pleaseEnterFullName;
    } else if (value.length < 2) {
      return AppConstants.globalKey.currentState!.context.translate.fullNameWithRange;
    }
    return null;
  }

  /// mobile validator
  static String? mobileNumber({required String value, String? errorTxt}) {
    if (AppValidator.isEmpty(value)) {
      return errorTxt ?? AppConstants.globalKey.currentState?.context.translate.pleaseEnterMobileNumber;
    } else if (!AppValidator.isMobile(value)) {
      return AppConstants.globalKey.currentState?.context.translate.pleaseEnterValidNumber;
    }
    return null;
  }

  static String? email({required String value, String? errorTxt}) {
    if (AppValidator.isEmpty(value)) {
      return errorTxt ?? AppConstants.globalKey.currentState?.context.translate.pleaseEnterEmail;
    } else if (!AppValidator.isEmail(value)) {
      return AppConstants.globalKey.currentState?.context.translate.pleaseEnterValidEmail;
    }
    return null;
  }

  /// price validator
  static String? price({required String value}) {
    if (AppValidator.isEmpty(value)) {
      return AppConstants.globalKey.currentState?.context.translate.pleaseEnterInspectionPrice;
    } else if (num.tryParse(value) == 0) {
      return AppConstants.globalKey.currentState?.context.translate.inspectionPriceShouldBeMoreThenZero;
    }
    return null;
  }

  /// price validator
  static String? minMaxRangeValidate({required String value}) {
    if (AppValidator.isEmpty(value)) {
      return AppConstants.globalKey.currentState?.context.translate.pleaseEnterIban;
    } else if (value.length < 24) {
      return AppConstants.globalKey.currentState?.context.translate.pleaseEnterValidIban;
    }
    return null;
  }
  //
  // /// email validator
  // static String? email({required String value}) {
  //   if (AppValidator.isEmpty(value)) {
  //     return AppStrings.enterEmail.tr;
  //   } else if (!AppValidator.isEmail(value)) {
  //     return "Please enter valid email";
  //   }
  //
  //   return null;
  // }

  // /// password validator
  // static String? password({
  //   required String value,
  // }) {
  //   if (AppValidator.isEmpty(value)) {
  //     return AppStrings.enterPassword.tr;
  //   } else if (!AppValidator.isPassword(value)) {
  //     // return _getPasswordValidationMessage(value);
  //     return "Please enter valid password";
  //   }
  //
  //   return null;
  // }

  // /// confirm password validator
  // static String? cnfPassword({
  //   required String password,
  //   required String cnfPassword,
  // }) {
  //   if (AppValidator.isEmpty(password)) {
  //     return AppStrings.reEnterPassword.tr;
  //   } else if (cnfPassword != password) {
  //     return "Passwords do not match.";
  //   }
  //
  //   return null;
  // }
  //
  // /// Mobile/Email validator
  // static String? mobileEmail({required String value}) {
  //   if (AppValidator.isEmpty(value)) {
  //     return AppStrings.enterMobileNumberOrEmail.tr;
  //   } else if (!(AppValidator.isEmail(value) || AppValidator.isMobile(value))) {
  //     return "Please enter valid email or mobile number";
  //   }
  //
  //   return null;
  // }

  static String _getPasswordValidationMessage(String password) {
    List<String> messages = [];

    if (password.length < 8) {
      messages.add("- At least 8 characters");
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      messages.add("- At least 1 uppercase letter (A-Z)");
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
      messages.add("- At least 1 lowercase letter (a-z)");
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      messages.add("- At least 1 number (0-9)");
    }
    if (!RegExp(r'(?=.*[\W_])').hasMatch(password)) {
      messages.add("- At least 1 special character");
    }

    return messages.isEmpty ? "" : messages.join("\n");
  }
}
