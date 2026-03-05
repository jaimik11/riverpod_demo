import 'package:json_annotation/json_annotation.dart';

enum NafathStatus {
  @JsonValue("0")
  pending,
  @JsonValue("1")
  approve,
  @JsonValue("2")
  partial,
  @JsonValue("3")
  rejected,
  none,
}
