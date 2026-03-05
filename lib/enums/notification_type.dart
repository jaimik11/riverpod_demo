import 'package:freezed_annotation/freezed_annotation.dart';

import '../gen/assets.gen.dart';

enum NotificationType {
  @JsonValue("id_verified")
  idVerified,
  unknown
}

extension NotificationTypeExtension on NotificationType {

  String get notificationIcon {
    switch (this) {
    
      case NotificationType.idVerified:
      case NotificationType.unknown:
        return "";

    }
  }
}