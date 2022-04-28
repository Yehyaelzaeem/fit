// To parse this JSON data, do
//
//     final MyMealResponse = MyMealResponseFromJson(jsonString);

import 'dart:convert';

MyMealResponse MyMealResponseFromJson(String str) => MyMealResponse.fromJson(json.decode(str));

class MyMealResponse {
  MyMealResponse({
    this.code,
    this.success,
    this.data,
  });

  final int? code;
  final bool? success;
  final List<SingleMyMeal>? data;

  factory MyMealResponse.fromJson(Map<String, dynamic> json) => MyMealResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : List<SingleMyMeal>.from(json["data"].map((x) => SingleMyMeal.fromJson(x))),
      );
}

class SingleMyMeal {
  SingleMyMeal({
    this.id,
    this.name,
    this.price,
    this.items,
    required this.selected,
  });

  bool selected;
  final int? id;
  final String? name;
  final int? price;
  final List<SingleMyMealItem>? items;

  factory SingleMyMeal.fromJson(Map<String, dynamic> json) => SingleMyMeal(
        selected: false,
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        items: json["items"] == null ? null : List<SingleMyMealItem>.from(json["items"].map((x) => SingleMyMealItem.fromJson(x))),
      );
}

class SingleMyMealItem {
  SingleMyMealItem({
    this.id,
    this.title,
    this.items,
    this.error,
  });

  final int? id;
  final String? title;
  final bool? error;
  final List<MealItem>? items;

  factory SingleMyMealItem.fromJson(Map<String, dynamic> json) => SingleMyMealItem(
        error: false,
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        items: json["items"] == null ? null : List<MealItem>.from(json["items"].map((x) => MealItem.fromJson(x))),
      );
}

class MealItem {
  MealItem({
    this.id,
    this.title,
    this.price,
    this.calories,
    this.amount,
  });

  final int? id;
  final String? title;
  final int? price;
  final int? calories;
  final int? amount;

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        price: json["price"] == null ? null : json["price"],
        calories: json["calories"] == null ? null : json["calories"],
        amount: json["amount"] == null ? null : json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "price": price == null ? null : price,
        "calories": calories == null ? null : calories,
        "amount": amount == null ? null : amount,
      };
}