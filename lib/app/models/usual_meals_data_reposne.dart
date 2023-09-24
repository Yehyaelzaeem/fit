class UsualMealsDataResponse {
  int? code;
  bool? success;
  Data? data;
  String? message;

  UsualMealsDataResponse({this.code, this.success, this.data});

  UsualMealsDataResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Food>? proteins;
  List<Food>? fats;
  List<Food>? carbs;

  Data({
    this.proteins,
    this.carbs,
    this.fats,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['proteins'] != null) {
      proteins = <Food>[];
      json['proteins'].forEach((v) {
        proteins!.add(new Food.fromJson(v));
      });
    }
    if (json['fats'] != null) {
      fats = <Food>[];
      json['fats'].forEach((v) {
        fats!.add(new Food.fromJson(v));
      });
    }
    if (json['carbs'] != null) {
      carbs = <Food>[];
      json['carbs'].forEach((v) {
        carbs!.add(new Food.fromJson(v));
      });
    }
  }
}

class FoodCaloriesDetails {
  int? id;
  double? qty;
  String? quality;
  dynamic calories;
  String? unit;
  String? color;
  String? total;

  FoodCaloriesDetails(
      {this.id,
      this.qty,
      this.quality,
      this.calories,
      this.unit,
      this.color,
        this.total});

  FoodCaloriesDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qty = json['qty'].toDouble();
    quality = json['quality'];
    calories = json['calorie_per_unit'];
    unit = json['unit'] ?? "GM";
    color = json['color'] ?? "FFFFFF";
    total =  json['calorie_per_unit']*json['qty'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qty'] = this.qty;
    data['quality'] = this.quality;
    data['calories'] = this.calories;
    return data;
  }
}

class Food {
  int? id;
  String? title;
  String? unit;
  var caloriePerUnit;
  String? color;
  bool? isSellected;
  double? qty;

  Food(
      {this.id,
      this.title,
      this.qty,
      this.unit,
      this.caloriePerUnit,
      this.color,
      this.isSellected});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    unit = json['unit'];
    caloriePerUnit = json['calorie_per_unit'].toDouble();
    color = json['color'];
    isSellected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['unit'] = this.unit;
    data['calorie_per_unit'] = this.caloriePerUnit;
    data['color'] = this.color;
    return data;
  }
}
