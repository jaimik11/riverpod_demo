import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {

  @JsonKey(name: 'status')
  final bool success;

  @JsonKey(name: 'message', defaultValue: '')
  final String message;

  @JsonKey(name: 'data')
  final T? jsonData;

  @JsonKey(name: "overall_rating")
  final String? overallRating;

  @JsonKey(name: "product_experience_avg")
  final String? productExperienceAvg;

  @JsonKey(name: "inspector_service_avg")
  final String? inspectorServiceAvg;

///"overall_rating": "1.5",
//     "product_experience_avg": "1.0",
//     "inspector_service_avg": "2.0"
  @JsonKey(name: "links")
  final Links? links;

  ApiResponse({
    this.message = '',
    this.jsonData,
    this.success = false,
    this.links,
    this.overallRating,
    this.productExperienceAvg,
    this.inspectorServiceAvg,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable()
class Links {
  @JsonKey(name: "first")
  final String first;
  @JsonKey(name: "last")
  final String last;
  @JsonKey(name: "prev")
  final String? prev;
  @JsonKey(name: "next")
  final String? next;

  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}