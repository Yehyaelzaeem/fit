class DayDetailsResponse {
  int? code;
  bool? success;
  Data? data;
  String? message;

  DayDetailsResponse({this.code, this.success, this.data});

  DayDetailsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['success'] == false ? json["message"] : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Days>? days;
  Proteins? proteins;
  Proteins? carbsFats;
  int? water;
  List<Workouts>? workouts;
  DayWorkouts? dayWorkouts;
  String? pdf;
  String? workoutDetails;
  String? workoutDetailsType;

  Data(
      {this.proteins,
      this.carbsFats,
      this.water,
      this.workouts,
      this.dayWorkouts,
      this.pdf,
      this.workoutDetails,
      this.days,
      this.workoutDetailsType});

  Data.fromJson(Map<String, dynamic> json) {
    proteins = json['proteins'] != null ? new Proteins.fromJson(json['proteins']) : null;
    carbsFats = json['carbs_fats'] != null ? new Proteins.fromJson(json['carbs_fats']) : null;
    water = json['water'];
    if (json['workouts'] != null) {
      workouts = <Workouts>[];
      json['workouts'].forEach((v) {
        workouts!.add(new Workouts.fromJson(v));
      });
    }
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(v));
      });
    }
    dayWorkouts =
        json['day_workouts'] != null ? new DayWorkouts.fromJson(json['day_workouts']) : null;
    pdf = json['pdf'];
    workoutDetails = json['workout_details'] ?? "";
    workoutDetailsType = json['workout_details_type'] ?? "";
  }
}

class Days {
  String? date;
  String? dateFormat;
  bool? active;

  Days({this.date, this.dateFormat, this.active});

  Days.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dateFormat = json['date_format'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['date_format'] = this.dateFormat;
    data['active'] = this.active;
    return data;
  }
}

class Proteins {
  CaloriesTotal? caloriesTotal;
  List<CaloriesDetails>? caloriesDetails;
  List<Food>? food;

  Proteins({this.caloriesTotal, this.caloriesDetails, this.food});

  Proteins.fromJson(Map<String, dynamic> json) {
    caloriesTotal =
        json['calories_total'] != null ? new CaloriesTotal.fromJson(json['calories_total']) : null;
    if (json['calories_details'] != null) {
      caloriesDetails = <CaloriesDetails>[];
      json['calories_details'].forEach((v) {
        caloriesDetails!.add(new CaloriesDetails.fromJson(v));
      });
    }
    if (json['food'] != null) {
      food = <Food>[];
      json['food'].forEach((v) {
        food!.add(new Food.fromJson(v));
      });
    }
  }
}

class CaloriesTotal {
  var taken;
  var imposed;
  Progress? progress;

  CaloriesTotal({this.taken, this.imposed, this.progress});

  CaloriesTotal.fromJson(Map<String, dynamic> json) {
    taken = json['taken'];
    imposed = json['imposed'];
    progress = json['progress'] != null ? new Progress.fromJson(json['progress']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taken'] = this.taken;
    data['imposed'] = this.imposed;
    if (this.progress != null) {
      data['progress'] = this.progress!.toJson();
    }
    return data;
  }
}

class Progress {
  var percentage;
  String? bg;

  Progress({this.percentage, this.bg});

  Progress.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    bg = json['bg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['percentage'] = this.percentage;
    data['bg'] = this.bg;
    return data;
  }
}

class CaloriesDetails {
  int? id;
  var qty;
  String? quality;
  var calories;
  String? createdAt;
  String? unit;
  String? color;

  CaloriesDetails(
      {this.id, this.qty, this.quality, this.calories, this.createdAt, this.unit, this.color});

  CaloriesDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qty = json['qty'];
    quality = json['quality'];
    calories = json['calories'];
    createdAt = json['created_at'];
    unit = json['unit'] ?? "GM";
    color = json['color'] ?? "FFFFFF";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qty'] = this.qty;
    data['quality'] = this.quality;
    data['calories'] = this.calories;
    data['created_at'] = this.createdAt;
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

  Food({this.id, this.title, this.unit, this.caloriePerUnit, this.color, this.isSellected});

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

// class CarbsFats {
//   CaloriesTotal? caloriesTotal;
//   List<Null>? caloriesDetails;
//   List<Food>? food;
//
//   CarbsFats({this.caloriesTotal, this.caloriesDetails, this.food});
//
//   CarbsFats.fromJson(Map<String, dynamic> json) {
//     caloriesTotal = json['calories_total'] != null
//         ? new CaloriesTotal.fromJson(json['calories_total'])
//         : null;
//     if (json['calories_details'] != null) {
//       caloriesDetails = new List<Null>();
//       json['calories_details'].forEach((v) {
//         caloriesDetails.add(new Null.fromJson(v));
//       });
//     }
//     if (json['food'] != null) {
//       food = new List<Food>();
//       json['food'].forEach((v) {
//         food.add(new Food.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.caloriesTotal != null) {
//       data['calories_total'] = this.caloriesTotal.toJson();
//     }
//     if (this.caloriesDetails != null) {
//       data['calories_details'] =
//           this.caloriesDetails.map((v) => v.toJson()).toList();
//     }
//     if (this.food != null) {
//       data['food'] = this.food.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Workouts {
  int? id;
  String? title;

  Workouts({this.id, this.title});

  Workouts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class DayWorkouts {
  String? workoutType;
  String? workoutDesc;

  DayWorkouts({this.workoutType, this.workoutDesc});

  DayWorkouts.fromJson(Map<String, dynamic> json) {
    workoutType = json['workout_type'];
    workoutDesc = json['workout_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workout_type'] = this.workoutType;
    data['workout_desc'] = this.workoutDesc;
    return data;
  }
}
