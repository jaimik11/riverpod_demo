
import 'package:freezed_annotation/freezed_annotation.dart';

enum InspectorStatus {
  inProcess,
  @JsonValue('pending')
  pending,
  @JsonValue('rejected')
  rejected,
  @JsonValue('accepted')
  accepted,
  @JsonValue('approved')
  approved,
  @JsonValue('unpaid')
  unpaid
}