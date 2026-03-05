import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../enums/app_status.dart';

part 'init_model.freezed.dart';
part 'init_model.g.dart';

@freezed
class InitModel with _$InitModel {

  const InitModel._();

  const factory InitModel({
    @JsonKey(name: "google_map_key") required String? googleMapKey,
    @JsonKey(name: "s3") S3Model? s3,
    @JsonKey(name: "deal_expiry_minutes") int? dealExpireMinutes,
    @JsonKey(name: "inspect_fee") num? inspectFee,
    @JsonKey(name: "maintenance", defaultValue: false) bool? maintenance,

    @JsonKey(name: "force_update", defaultValue: false) bool? forceUpdate,

    @JsonKey(name: "update", defaultValue: false) bool? update,
    @JsonKey(name: "nafath_signature_url",) String? nafathSignatureUrl,
    @JsonKey(name: "seller_nafath_signature_url",) String? sellerNafathSignatureUrl,
  }) = _InitModel;

  factory InitModel.fromJson(Map<String, dynamic> json) {

    return InitModel(
      googleMapKey: json['google_map_key'] as String?,
      s3: json['s3'] != null ? S3Model.fromJson(json['s3']) : null,
      dealExpireMinutes: json['deal_expiry_minutes'] as int?,
      inspectFee: json['inspect_fee'] as num?,
      maintenance: json['maintenance'] as bool? ?? false,
      forceUpdate: json['force_update'] as bool? ?? false,
      update: json['update'] as bool? ?? false,
      nafathSignatureUrl: json['nafath_signature_url'] as String?,
      sellerNafathSignatureUrl: json['seller_nafath_signature_url'] as String?,
    );
  }

  AppStatus get appStatus {
    if (maintenance ?? false) {
      return AppStatus.maintenance;
    } else if (forceUpdate ?? false) {
      return AppStatus.forceUpdate;
    } else if (update ?? false) {
      return AppStatus.optionalUpdate;
    } else {
      return AppStatus.normal;
    }
  }

}

@freezed
class S3Model with _$S3Model {
  const factory S3Model({
    @JsonKey(name: "key") required String? accessKey,
    @JsonKey(name: "secret") required String? secretKey,
    @JsonKey(name: "bucket") required String? bucketName,
    @JsonKey(name: "region") required String? region,
    @JsonKey(name: "url") required String? url,
  }) = _S3Model;

  factory S3Model.fromJson(Map<String, dynamic> json) =>
      _$S3ModelFromJson(json);

  static const String s3BucketSlug = "street_deals";
}
