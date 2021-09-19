import 'package:app/app/models/day_details_reposne.dart';

class SessionDetailsResponse {
  int? code;
  bool? success;
  Data? data;

  SessionDetailsResponse({this.code, this.success, this.data});

  SessionDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? date;
  String? status;
  String? height;
  String? totalWeight;
  String? fats;
  String? muscles;
  String? water;
  String? bodyComposition;
  int? proteinsCalories;
  int? carbsFatsCalories;
  String? followUp;
  List<FollowUpTable>? followUpTable;

  Data(
      {this.id,
      this.date,
      this.status,
      this.height,
      this.totalWeight,
      this.fats,
      this.muscles,
      this.water,
      this.bodyComposition,
      this.proteinsCalories,
      this.carbsFatsCalories,
      this.followUp,
      this.followUpTable});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    status = json['status'];
    height = json['height'];
    totalWeight = json['total_weight'];
    fats = json['fats'];
    muscles = json['muscles'];
    water = json['water'];
    bodyComposition = json['body_composition'];
    proteinsCalories = json['proteins_calories'];
    carbsFatsCalories = json['carbs_fats_calories'];
    followUp = json['follow_up'];
    if (json['follow_up_table'] != null) {
      followUpTable = <FollowUpTable>[];
      json['follow_up_table'].forEach((v) {
        followUpTable!.add(new FollowUpTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['status'] = this.status;
    data['height'] = this.height;
    data['total_weight'] = this.totalWeight;
    data['fats'] = this.fats;
    data['muscles'] = this.muscles;
    data['water'] = this.water;
    data['body_composition'] = this.bodyComposition;
    data['proteins_calories'] = this.proteinsCalories;
    data['carbs_fats_calories'] = this.carbsFatsCalories;
    data['follow_up'] = this.followUp;
    if (this.followUpTable != null) {
      data['follow_up_table'] = this.followUpTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowUpTable {
  int? id;
  ProteinsCalories? proteinsCalories;
  ProteinsCalories? carbsFatsCalories;
  ProteinsCalories? total;
  String? date;
  int? water;
  bool? isSellected;
  DayWorkouts? workout;
  CaloriesTable? caloriesTable;

  FollowUpTable(
      {this.id,
      this.proteinsCalories,
      this.carbsFatsCalories,
      this.date,
      this.water,
      this.isSellected,
      this.workout,
      this.caloriesTable});

  FollowUpTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSellected = false;
    proteinsCalories = json['proteins_calories'] != null
        ? new ProteinsCalories.fromJson(json['proteins_calories'])
        : null;
    carbsFatsCalories = json['carbs_fats_calories'] != null
        ? new ProteinsCalories.fromJson(json['carbs_fats_calories'])
        : null;
   total = json['total_calories'] != null
        ? new ProteinsCalories.fromJson(json['total_calories'])
        : null;
    date = json['date'];
    water = json['water'];
    workout = json['workout'] != null ? new DayWorkouts.fromJson(json['workout']) : null;

    caloriesTable =
        json['calories_table'] != null ? new CaloriesTable.fromJson(json['calories_table']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.proteinsCalories != null) {
      data['proteins_calories'] = this.proteinsCalories!.toJson();
    }
    if (this.carbsFatsCalories != null) {
      data['carbs_fats_calories'] = this.carbsFatsCalories!.toJson();
    }
    data['date'] = this.date;
    data['water'] = this.water;
    data['workout'] = this.workout;
    // if (this.caloriesTable != null) {
    //   data['calories_table'] = this.caloriesTable!.toJson();
    // }
    return data;
  }
}

class ProteinsCalories {
  String? taken;
  int? imposed;

  ProteinsCalories({this.taken, this.imposed});

  ProteinsCalories.fromJson(Map<String, dynamic> json) {
    taken = json['taken'];
    imposed = json['imposed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taken'] = this.taken;
    data['imposed'] = this.imposed;
    return data;
  }
}

class CaloriesTable {
  List<CarbsFatsTable>? proteinsCaloriesTable;
  List<CarbsFatsTable>? carbsFatsTable;

  CaloriesTable({this.proteinsCaloriesTable, this.carbsFatsTable});

  CaloriesTable.fromJson(Map<String, dynamic> json) {
    if (json['proteins_calories_table'] != null) {
      proteinsCaloriesTable = <CarbsFatsTable>[];
      json['proteins_calories_table'].forEach((v) {
        proteinsCaloriesTable!.add(new CarbsFatsTable.fromJson(v));
      });
    }
    if (json['carbs_fats_table'] != null) {
      carbsFatsTable = <CarbsFatsTable>[];
      json['carbs_fats_table'].forEach((v) {
        carbsFatsTable!.add(new CarbsFatsTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.proteinsCaloriesTable != null) {
      data['proteins_calories_table'] = this.proteinsCaloriesTable!.map((v) => v.toJson()).toList();
    }
    if (this.carbsFatsTable != null) {
      data['carbs_fats_table'] = this.carbsFatsTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarbsFatsTable {
  String? qty;
  String? quality;
  var calories;
  String? color;

  CarbsFatsTable({this.qty, this.quality, this.calories, this.color});

  CarbsFatsTable.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    quality = json['quality'];
    calories = json['calories'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    data['quality'] = this.quality;
    data['calories'] = this.calories;
    data['color'] = this.color;
    return data;
  }
}
