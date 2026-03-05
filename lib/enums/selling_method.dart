import 'package:c2c/constants/app_constants.dart';
import 'package:c2c/l10n/localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'language_code.dart';

enum SellingMethod { byPrice, byMakeOffer }

enum DeliveryMethod {
  @JsonValue('shipping')
  productShipping,
  @JsonValue('self_pickup')
  selfPickup,
}

extension DeliveryMethodExtension on DeliveryMethod {
  String get value {
    switch (this) {
      case DeliveryMethod.productShipping:
        return AppConstants
            .globalKey
            .currentContext!
            .translate
            .productShippingFromBuyerToSeller;
      case DeliveryMethod.selfPickup:
        return AppConstants.globalKey.currentContext!.translate.selfPickup;
    }
  }

  String get apiName {
    switch (this) {
      case DeliveryMethod.productShipping:
        return 'shipping';
      case DeliveryMethod.selfPickup:
        return 'self_pickup';
    }
  }
}


enum CostOnMethod {
  @JsonValue('seller')
  seller,
  @JsonValue('buyer')
  buyer,
}

extension CostOnMethodExtension on CostOnMethod {
  String get value {
    switch (this) {
      case CostOnMethod.seller:
        return AppConstants
            .globalKey
            .currentContext!
            .translate
            .seller;
      case CostOnMethod.buyer:
        return AppConstants.globalKey.currentContext!.translate.buyer;
    }
  }

  String get apiName {
    switch (this) {
      case CostOnMethod.seller:
        return 'seller';
      case CostOnMethod.buyer:
        return 'buyer';
    }
  }
}

enum PaymentMethod {
  @JsonValue('buyer_to_seller')
  buyerToSeller,
  @JsonValue('c2c_to_seller')
  c2cToSeller,
}

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.buyerToSeller:
        return AppConstants.globalKey.currentContext!.translate.fromBuyerToSeller;
      case PaymentMethod.c2cToSeller:
        return AppConstants.globalKey.currentContext!.translate.fromC2CToSeller;

    }
  }

  String get apiName {
    switch (this) {
      case PaymentMethod.buyerToSeller:
        return 'buyer_to_seller';
      case PaymentMethod.c2cToSeller:
        return 'c2c_to_seller';
    }
  }
}
