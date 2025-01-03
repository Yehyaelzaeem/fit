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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data!.toJson();
    return data;
  }
}

class Data {
  List<FoodDataItem>? proteins;
  List<FoodDataItem>? fats;
  List<FoodDataItem>? carbs;

  Data({
    this.proteins,
    this.carbs,
    this.fats,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['proteins'] != null) {
      proteins = <FoodDataItem>[];
      json['proteins'].forEach((v) {
        proteins!.add(new FoodDataItem.fromJson(v));
      });
    }
    if (json['fats'] != null) {
      fats = <FoodDataItem>[];
      json['fats'].forEach((v) {
        fats!.add(new FoodDataItem.fromJson(v));
      });
    }
    if (json['carbs'] != null) {
      carbs = <FoodDataItem>[];
      json['carbs'].forEach((v) {
        carbs!.add(new FoodDataItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.proteins != null) {
      data['proteins'] =
          this.proteins!.map((v) => v.toJson()).toList();
    }
    if (this.carbs != null) {
      data['carbs'] =
          this.carbs!.map((v) => v.toJson()).toList();
    }
    if (this.fats != null) {
      data['fats'] =
          this.fats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/*
class FoodCaloriesDetails {
  int? id;
  double? qty;
  String? quality;
  dynamic caloriePerUnit;
  String? unit;
  String? color;
  String? total;

  FoodCaloriesDetails(
      {this.id,
      this.qty,
      this.quality,
      this.caloriePerUnit,
      this.unit,
      this.color,
        this.total});

  FoodCaloriesDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qty = json['qty'].toDouble();
    quality = json['quality'];
    caloriePerUnit = json['calorie_per_unit'];
    unit = json['unit'] ?? "GM";
    color = json['color'] ?? "FFFFFF";
    total =  json['calorie_per_unit']*json['qty'].toDouble();
  }
}
*/

class FoodDataItem {
  int? id;
  String? title;
  String? unit;
  dynamic caloriePerUnit;
  String? color;
  bool? isSellected;
  dynamic qty;
  dynamic total;

  FoodDataItem(
      {this.id,
      this.title,
      this.qty,
      this.unit,
      this.caloriePerUnit,
      this.color,
      this.total,
      this.isSellected});

  FoodDataItem.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    title = json?['title'];
    unit = json?['unit'];
    caloriePerUnit = json?['calorie_per_unit'].toDouble();
    color = json?['color'];
    isSellected = false;
    total =  json?['calorie_per_unit']??0.0*json?['qty']??0.0.toDouble();
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
