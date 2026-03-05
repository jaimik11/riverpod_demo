import 'package:c2c/constants/api_constants.dart';
import 'package:c2c/enums/language_code.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/app_constants.dart';
import '../gen/assets.gen.dart';

enum SectionType {
  image,
  title,
  description
}

SectionType sectionTypeFromString(String type) {
  switch (type) {
    case 'image':
      return SectionType.image;
    case 'title':
      return SectionType.title;
    case 'description':
      return SectionType.description;

    default:
      throw Exception("Unknown section type: $type");
  }
}
