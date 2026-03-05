import 'package:freezed_annotation/freezed_annotation.dart';

enum ProductStatus{
  @JsonValue("1")
  active,
  @JsonValue("0")
  inactive,
}

