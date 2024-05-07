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
  List<Days>? days;
  Proteins? proteins;
  Proteins? carbs;
  Proteins? fats;
  int? water;
  List<Workouts>? workouts;
  DayWorkouts? dayWorkouts;
  String? pdf;
  String? workoutDetails;
  String? workoutDetailsType;
  SleepingTime? sleepingTime;

  Data(
      {this.proteins,
      this.carbs,
      this.fats,
      this.water,
      this.workouts,
      this.dayWorkouts,
      this.pdf,
      this.workoutDetails,
      this.days,
      this.workoutDetailsType,
      this.sleepingTime});

  Data.fromJson(Map<String, dynamic> json) {
    proteins = json['proteins'] != null
        ? new Proteins.fromJson(json['proteins'])
        : null;
    carbs = json['carbs_fats'] != null
        ? new Proteins.fromJson(json['carbs_fats'])
        : null;
    fats = json['fats'] != null ? new Proteins.fromJson(json['fats']) : null;
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
    dayWorkouts = json['day_workouts'] != null
        ? new DayWorkouts.fromJson(json['day_workouts'])
        : null;
    pdf = json['pdf'];
    workoutDetails = json['workout_details'] ?? "";
    workoutDetailsType = json['workout_details_type'] ?? "";
    sleepingTime = json['sleeping_time'] != null
        ? new SleepingTime.fromJson(json['sleeping_time'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['proteins'] = this.proteins!.toJson();
    data['carbs_fats'] = this.carbs!.toJson();
    data['fats'] = this.fats!.toJson();
    data['water'] = this.water;
        if (this.workouts != null) {
      data['workouts'] =
          this.workouts!.map((v) => v.toJson()).toList();
    }
        if (this.days != null) {
      data['days'] =
          this.days!.map((v) => v.toJson()).toList();
    }
        if (this.dayWorkouts != null) {
      data['day_workouts'] =
          this.dayWorkouts!.toJson();
    }
    data['pdf'] = this.pdf;
    data['workout_details'] = this.workoutDetails;
    data['workout_details_type'] = this.workoutDetailsType;
    data['sleeping_time'] = this.sleepingTime?.toJson();

    return data;
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
    caloriesTotal = json['calories_total'] != null
        ? new CaloriesTotal.fromJson(json['calories_total'])
        : null;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories_total'] = this.caloriesTotal?.toJson();
    if (this.caloriesDetails != null) {
      data['calories_details'] =
          this.caloriesDetails!.map((v) => v.toJson()).toList();
    }
    if (this.food != null) {
      data['food'] =
          this.food!.map((v) => v.toJson()).toList();
    }
    return data;
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
    progress = json['progress'] != null
        ? new Progress.fromJson(json['progress'])
        : null;
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
  int? randomId;
  double? qty;
  String? quality;
  var calories;
  String? createdAt;
  String? unit;
  String? color;

  CaloriesDetails(
      {this.id,
        this.randomId,
      this.qty,
      this.quality,
      this.calories,
      this.createdAt,
      this.unit,
      this.color});

  CaloriesDetails.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    randomId = json['randomId'];
    qty = json['qty'].toDouble();
    quality = json['quality'];
    calories = json['calories'];
    createdAt = json['created_at'];
    unit = json['unit'] ?? "GM";
    color = json['color'] ?? "FFFFFF";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['randomId'] = this.randomId;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['quality'] = this.quality;
    data['calories'] = this.calories;
    data['color'] = this.color;
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

class SleepingTime {
  String? sleepingFrom;
  String? sleepingTo;
  String? sleepingDuration;
  SleepingStatus? sleepingStatus;

  SleepingTime(
      {this.sleepingFrom,
      this.sleepingTo,
      this.sleepingDuration,
      this.sleepingStatus});

  SleepingTime.fromJson(Map<String, dynamic> json) {
    sleepingFrom = json['sleeping_from'];
    sleepingTo = json['sleeping_to'];
    sleepingDuration = json['sleeping_duration'];
    sleepingStatus = json['sleeping_status'] != null
        ? new SleepingStatus.fromJson(json['sleeping_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sleeping_from'] = this.sleepingFrom;
    data['sleeping_to'] = this.sleepingTo;
    data['sleeping_duration'] = this.sleepingDuration;
    data['sleeping_status'] = this.sleepingStatus?.toJson();
    return data;
  }
}

class SleepingStatus {
  int? id;
  String? name;
  String? image;

  SleepingStatus({
    this.id,
    this.name,
    this.image,
  });

  SleepingStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
