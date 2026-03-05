import 'dart:ui';

import 'package:c2c/enums/text_color_type.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:c2c/theme/app_colors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/app_constants.dart';
import 'language_code.dart';

enum OrderStatus {
  all,
  openOrder,
  inProcess,
  @JsonValue('pending')
  pending,
  @JsonValue('cancelled')
  cancelled,
  delivered,
  @JsonValue('paid')
  paid,
  @JsonValue('waiting')
  waiting,
  @JsonValue('rejected')
  rejected,
  @JsonValue('sold')
  sold,
  @JsonValue('auto_cancelled')
  autoCancelled,
  @JsonValue('accepted')
  accepted,
  @JsonValue('approved')
  approved,
  @JsonValue('unpaid')
  unpaid,
  @JsonValue('waiting_for_approval')
  waitingForApproval,
  @JsonValue('waiting_for_payment')
  waitingForPayment,

  //INSPECTOR DEAL ENUMS
  @JsonValue('success')
  success,
  @JsonValue('failed')
  failed,
}

extension OrderStatusExtension on OrderStatus {
  
  String get value {
    switch (this) {
      case OrderStatus.inProcess:
        return AppConstants.globalKey.currentState!.context.translate.inProcess;
      case OrderStatus.pending:
        return AppConstants.globalKey.currentState!.context.translate.waiting;
      case OrderStatus.cancelled:
        return AppConstants.globalKey.currentState!.context.translate.cancelled;
      case OrderStatus.delivered:
        return AppConstants.globalKey.currentState!.context.translate.delivered;
      case OrderStatus.paid:
        return AppConstants.globalKey.currentState!.context.translate.paid;
      case OrderStatus.waiting:
        return AppConstants.globalKey.currentState!.context.translate.waiting;
      case OrderStatus.rejected:
        return AppConstants.globalKey.currentState!.context.translate.rejected;
      case OrderStatus.sold:
        return AppConstants.globalKey.currentState!.context.translate.sold;
      case OrderStatus.autoCancelled:
        return AppConstants.globalKey.currentState!.context.translate.cancelled;
      case OrderStatus.accepted:
        return AppConstants.globalKey.currentState!.context.translate.accepted;
      case OrderStatus.unpaid:
        return AppConstants.globalKey.currentState!.context.translate.unPaid;
      case OrderStatus.approved:
        return AppConstants.globalKey.currentState!.context.translate.approved;
      case OrderStatus.success:
        return AppConstants.globalKey.currentState!.context.translate.success;
      case OrderStatus.failed:
        return AppConstants.globalKey.currentState!.context.translate.failed;
      case OrderStatus.all:
        return AppConstants.globalKey.currentState!.context.translate.all;
      case OrderStatus.openOrder:
        return AppConstants.globalKey.currentState!.context.translate.openOrder;
      case OrderStatus.waitingForApproval:
        return AppConstants.globalKey.currentState!.context.translate.waitingForApproval;
      case OrderStatus.waitingForPayment:
        return AppConstants.globalKey.currentState!.context.translate.waitingForPayment;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.pending:
        return AppColors.pending.withValues(alpha: 0.4);
      case OrderStatus.accepted:
      case OrderStatus.waitingForApproval:
      case OrderStatus.waitingForPayment:
        return AppColors.primary.withValues(alpha: 0.6);

      case OrderStatus.success:
        return AppColors.greenColor;
      case OrderStatus.rejected:
      case OrderStatus.failed:
      case OrderStatus.cancelled:
      case OrderStatus.autoCancelled:
        return AppColors.red;

      default:
        return AppColors.greenColor;
    }
  }

  Color get textColor {
    switch (this) {
      case OrderStatus.rejected:
      case OrderStatus.paid:
      case OrderStatus.cancelled:
      case OrderStatus.autoCancelled:
      case OrderStatus.failed:
      case OrderStatus.success:
        return AppColors.white;

      default:
        return TextColorType.defaultColor.resolve(
          AppConstants.globalKey.currentState!.context,
        );
    }
  }
}