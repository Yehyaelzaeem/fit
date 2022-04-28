// To parse this JSON data, do
//
//     final mealFoodListResponse = mealFoodListResponseFromJson(jsonString);

import 'dart:convert';

MealFoodListResponse mealFoodListResponseFromJson(String str) => MealFoodListResponse.fromJson(json.decode(str));

class MealFoodListResponse {
  MealFoodListResponse({
    this.code,
    this.success,
    this.data,
  });

  final int? code;
  final bool? success;
  final List<SingleMeal>? data;

  factory MealFoodListResponse.fromJson(Map<String, dynamic> json) => MealFoodListResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : List<SingleMeal>.from(json["data"].map((x) => SingleMeal.fromJson(x))),
      );
}

class SingleMeal {
  SingleMeal({
    this.id,
    this.title,
    this.food,
  });

  final int? id;
  final String? title;
  final List<Food>? food;

  factory SingleMeal.fromJson(Map<String, dynamic> json) => SingleMeal(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        food: json["food"] == null ? null : List<Food>.from(json["food"].map((x) => Food.fromJson(x))),
      );
}

class Food {
  Food({
    this.id,
    this.title,
    this.amounts,
    required this.selectedAmount,
  });

  int? id;
  String? title;
  List<Amount>? amounts;
  Amount selectedAmount;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        amounts: json["amounts"] == null ? null : List<Amount>.from(json["amounts"].map((x) => Amount.fromJson(x))),
        selectedAmount: Amount(
          id: 0,
          calories: "",
          name: "",
          price: "",
        ),
      );
}

class Amount {
  Amount({
    required this.id,
    required this.name,
    required this.calories,
    required this.price,
  });

  final int id;
  final String name;
  final String calories;
  final String price;

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
        id: json["id"] == null ? 0 : json["id"],
        name: json["name"] == null ? '' : json["name"],
        calories: json["calories"] == null ? '' : "${json["calories"]}",
        price: json["price"] == null ? '' : "${json["price"]}",
      );
}
