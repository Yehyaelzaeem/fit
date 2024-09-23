
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

DateTime getEgyptTime(){
  final egyptTimeZone = tz.getLocation('Africa/Cairo');
  final nowInEgypt = tz.TZDateTime.now(egyptTimeZone);
  final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(nowInEgypt);

  return DateTime.parse(formattedTime);

}

class DiaryData {
  final String date;
  final String? water;
  final int? foodProtine;
  final double? qtyProtiene;
  final int? workOut;
  final String? workoutDesc;
  final int? randomId;
  final int? id;
  final String? foodName;
  final String? dateTime;
  dynamic caloriesPerUnit;

  DiaryData({
    required this.date,
    this.water,
    this.foodProtine,
    this.qtyProtiene,
    this.workOut,
    this.workoutDesc,
    this.randomId,
    this.id,
    this.foodName,
    this.dateTime,
    this.caloriesPerUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'water': water,
      'foodProtine': foodProtine,
      'qtyProtiene': qtyProtiene,
      'workOut': workOut,
      'workoutDesc': workoutDesc,
      'randomId': randomId,
      'id': id,
      'foodName': foodName,
      'caloriesPerUnit': caloriesPerUnit,
      'dateTime': getEgyptTime().toString().substring(0,16),
    };
  }

  factory DiaryData.fromJson(Map<String, dynamic> json) {
    return DiaryData(
      date: json['date'],
      water: json['water'],
      foodProtine: json['foodProtine'],
      qtyProtiene: json['qtyProtiene'],
      workOut: json['workOut'],
      workoutDesc: json['workoutDesc'],
      randomId: json['randomId'],
      id: json['id'],
      foodName: json['foodName'],
      dateTime: json['dateTime'],
      caloriesPerUnit: json['caloriesPerUnit'],
    );
  }
}

class UsualMealData {
  final String name;
  final String? foodId;
  final String? qty;
  final int? id;

  UsualMealData({
    required this.name,
    this.foodId,
    this.qty,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'food_id': foodId,
      'qty': qty,
      'id': id,
    };
  }

  factory UsualMealData.fromJson(Map<String, dynamic> json) {
    return UsualMealData(
      name: json['name'],
      foodId: json['food_id'],
      qty: json['qty'],
      id: json['id'],
    );
  }
}

class OtherMealData {
  final String? title;
  final String? calPerUnit;
  final int? unit;
  final String? unitQuantity;
  final String? unitName;
  final int? type;
  final int? id;

  OtherMealData({
    required this.title,
    required this.calPerUnit,
    required this.unit,
    this.unitQuantity,
    this.unitName,
    this.type,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'calPerUnti': calPerUnit,
      'unit': unit,
      'unitQuantity': unitQuantity,
      'unitName': unitName,
      'type': type,
      'id': id,
    };
  }

  factory OtherMealData.fromJson(Map<String, dynamic> json) {
    return OtherMealData(
      title: json['title'],
      calPerUnit: json['calPerUnti'],
      unit: json['unit'],
      unitQuantity: json['unitQuantity'],
      unitName: json['unitName'],
      type: json['type'],
      id: json['id'],
    );
  }


}

class DiaryEntry {
  String date;
  int water;
  List<int> food;
  List<double> qty;
  List<String> createdAt;
  int? workout;
  String? workoutDesc;

  DiaryEntry({
    required this.date,
    required this.water,
    required this.food,
    required this.qty,
    required this.createdAt,
    this.workout,
    this.workoutDesc,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'water': water,
      'food': food,
      'qty': qty,
      'created_at': createdAt,
      'workout': workout,
      'workout_desc': workoutDesc,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      date: json['date'],
      water: json['water'],
      food: List<int>.from(json['food']),
      qty: List<double>.from(json['qty']),
      createdAt: List<String>.from(json['created_at']),
      workout: json['workout'],
      workoutDesc: json['workout_desc'],
    );
  }
}
