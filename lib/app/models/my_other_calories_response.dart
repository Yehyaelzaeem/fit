class MyOtherCaloriesResponse {
  int? code;
  bool? success;
  Data? data;

  MyOtherCaloriesResponse({this.code, this.success, this.data});

  MyOtherCaloriesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Proteins>? proteins;
  List<Proteins>? carbsFats;

  Data({this.proteins, this.carbsFats});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['proteins'] != null) {
      proteins = <Proteins>[];
      json['proteins'].forEach((v) {
        proteins!.add(new Proteins.fromJson(v));
      });
    }
    if (json['carbs_fats'] != null) {
      carbsFats = <Proteins>[];
      json['carbs_fats'].forEach((v) {
        carbsFats!.add(new Proteins.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.proteins != null) {
      data['proteins'] = this.proteins!.map((v) => v.toJson()).toList();
    }
    if (this.carbsFats != null) {
      data['carbs_fats'] = this.carbsFats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Proteins {
  int? id;
  String? title;
  String? qty;
  num? calorie_per_unit;
  var calories;

  Proteins(
      {this.id, this.title, this.qty, this.calories, this.calorie_per_unit});

  Proteins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    qty = json['qty'];
    calories = json['calories'];
    calorie_per_unit = json['calorie_per_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['qty'] = this.qty;
    data['calories'] = this.calories;
    data['calorie_per_unit'] = this.calorie_per_unit;
    return data;
  }
}
