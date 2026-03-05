import 'package:json_annotation/json_annotation.dart';

enum PaymentStatus {
  @JsonValue("0")
  pending,
  @JsonValue("1")
  paid,
  none,
}
