
import 'package:app/core/models/usual_meals_data_reposne.dart';

class UsualMealsResponse {
  int? code;
  bool? success;
  List<MealData>? data;
  String? message;

  UsualMealsResponse({this.code, this.success, this.data});

  UsualMealsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MealData>[];
      json['data'].forEach((v) {
        data!.add(new MealData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealData {
  int? id;
  String? name;
  dynamic totalCalories;
  UsualProteins? proteins;
  UsualProteins? carbs;
  UsualProteins? fats;

  MealData(
      {this.id,
        this.name,
        this.totalCalories,
        this.proteins,
        this.carbs,
        this.fats});

  MealData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalCalories = json['total_calories'];
    proteins = json['proteins'] != null
        ? new UsualProteins.fromJson(json['proteins'])
        : null;
    carbs = json['carbs'] != null ? new UsualProteins.fromJson(json['carbs']) : null;
    fats = json['fats'] != null ? new UsualProteins.fromJson(json['fats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total_calories'] = this.totalCalories;
    if (this.proteins != null) {
      data['proteins'] = this.proteins!.toJson();
    }
    if (this.carbs != null) {
      data['carbs'] = this.carbs!.toJson();
    }
    if (this.fats != null) {
      data['fats'] = this.fats!.toJson();
    }
    return data;
  }
}

class UsualProteins {
  dynamic calories;
  List<Items>? items;

  UsualProteins({this.calories, this.items});

  UsualProteins.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  FoodDataItem? food;
  dynamic qty;
  dynamic calories;

  Items({this.id, this.food, this.qty, this.calories});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    food = json['food'] != null ? new FoodDataItem.fromJson(json['food']) : null;
    qty = json['qty'];
    calories = json['calories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qty'] = this.qty;
    data['calories'] = this.calories;
    data['food'] = this.food?.toJson();
    return data;
  }
}

/*class FoodItem {
  int? id;
  String? title;
  String? unit;
  dynamic caloriePerUnit;
  String? color;





  FoodItem({this.id, this.title, this.unit, this.caloriePerUnit, this.color});

  FoodItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    unit = json['unit'];
    caloriePerUnit = json['calorie_per_unit'];
    color = json['color'];
  }
}*/


