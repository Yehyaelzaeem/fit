// To parse this JSON data, do
//
//     final mealFeatureStatusResponse = mealFeatureStatusResponseFromJson(jsonString);

import 'dart:convert';

MealFeatureStatusResponse mealFeatureStatusResponseFromJson(String str) =>
    MealFeatureStatusResponse.fromJson(json.decode(str));

String mealFeatureStatusResponseToJson(MealFeatureStatusResponse data) =>
    json.encode(data.toJson());

class MealFeatureStatusResponse {
  MealFeatureStatusResponse({
    this.code,
    this.success,
    this.data,
  });

  final int? code;
  final bool? success;
  final Data? data;

  factory MealFeatureStatusResponse.fromJson(Map<String, dynamic> json) =>
      MealFeatureStatusResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "success": success == null ? null : success,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.isActive,
  });

  final bool? isActive;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isActive: json["is_active"] == null ? null : json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive == null ? null : isActive,
      };
}
