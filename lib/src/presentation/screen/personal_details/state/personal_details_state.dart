import 'package:c2c/src/presentation/screen/personal_details/personal_details_args.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

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
  }) = _PersonalDetailsState;
}
