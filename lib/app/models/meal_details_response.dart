// To parse this JSON data, do
//
//     final mealDetailsResponse = mealDetailsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:app/app/models/mymeals_response.dart';

MealDetailsResponse mealDetailsResponseFromJson(String str) =>
    MealDetailsResponse.fromJson(json.decode(str));

class MealDetailsResponse {
  MealDetailsResponse({
    this.code,
    this.success,
    this.data,
  });

  final int? code;
  final bool? success;
  final SingleMyMeal? data;

  factory MealDetailsResponse.fromJson(Map<String, dynamic> json) =>
      MealDetailsResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : SingleMyMeal.fromJson(json["data"]),
      );
}
