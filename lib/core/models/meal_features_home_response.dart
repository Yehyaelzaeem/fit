// To parse this JSON data, do
//
//     final mealFeatureStatusResponse = mealFeatureStatusResponseFromJson(jsonString);

import 'dart:convert';

MealFeatureStatusResponse mealFeatureStatusResponseFromJson(String str) =>
    MealFeatureStatusResponse.fromJson(json.decode(str));


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
}

class Data {
  Data({
    this.isActive,
    this.deliveryActive,
    this.pickupActive,
  });

  final bool? isActive;
  final bool? deliveryActive;
  final bool? pickupActive;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isActive: json["is_active"] == null ? null : json["is_active"],
        deliveryActive:
            json["delivery_option"] == null ? null : json["delivery_option"],
        pickupActive:
            json["pickup_option"] == null ? null : json["pickup_option"],
      );
}
