// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'package:c2c/enums/notification_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: "id")
    String? id,
    @JsonKey(name: "title")
    String? title,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "type")
    NotificationType? type,
    @JsonKey(name: "variables")
    Variables? variables,
    @JsonKey(name: "read_at")
    dynamic readAt,
    @JsonKey(name: "created_at")
    String? createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  static List<NotificationModel> dummyNotificationItemsList({int length = 15}) {
    return List.generate(
      length,
          (index) => NotificationModel.fromJson({
            "id": "bfa5c5fe-8523-42b4-bc76-25e55f318de4",
            "title": "C2C deals",
            "message": "You Baskte Code is 250702840997 from +966 123456789",
            "type": "deal_create",
            "variables": {
              "deal_id": 13,
              "from_mobile": "+966 123456789",
              "product_code": "250702840997"
            },
            "read_at": null,
            "created_at": "3 minutes ago"
      },),
    );
  }

}

@freezed
class Variables with _$Variables {
  const factory Variables({
    @JsonKey(name: "deal_id")
    int? dealId,
    @JsonKey(name: "from_mobile")
    String? fromMobile,
    @JsonKey(name: "product_code")
    String? productCode,
  }) = _Variables;

  factory Variables.fromJson(Map<String, dynamic> json) => _$VariablesFromJson(json);
}
