import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../enums/language_code.dart';

part 'personal_details_state.freezed.dart';

@freezed
abstract class PersonalDetailsState with _$PersonalDetailsState {
  factory PersonalDetailsState({
    required GlobalKey<FormState> formKey,
    @Default(null) TextEditingController? nameController,
    @Default(null) TextEditingController? mobileNumberController,
    @Default(null) FocusNode? nameNode,
    @Default(null) FocusNode? numberNode,
    @Default('') String selectedImage,
    @Default(null) LanguageCode? selectedLocale,

  }) = _PersonalDetailsState;
}
