// To parse this JSON data, do
//
//     final mealFeatureHomeResponse = mealFeatureHomeResponseFromJson(jsonString);

import 'dart:convert';

MealFeatureHomeResponse mealFeatureHomeResponseFromJson(String str) => MealFeatureHomeResponse.fromJson(json.decode(str));

class MealFeatureHomeResponse {
  MealFeatureHomeResponse({
    this.code,
    this.success,
    this.data,
  });

  final int? code;
  final bool? success;
  final Data? data;

  factory MealFeatureHomeResponse.fromJson(Map<String, dynamic> json) => MealFeatureHomeResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.sliders,
    this.info,
  });

  final List<Slider>? sliders;
  final Info? info;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sliders: json["sliders"] == null ? null : List<Slider>.from(json["sliders"].map((x) => Slider.fromJson(x))),
        info: json["info"] == null ? null : Info.fromJson(json["info"]),
      );
}

class Info {
  Info({
    this.about,
    this.location,
  });

  final String? about;
  final String? location;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        about: json["about"] == null ? null : json["about"],
        location: json["location"] == null ? null : json["location"],
      );

  Map<String, dynamic> toJson() => {
        "about": about == null ? null : about,
        "location": location == null ? null : location,
      };
}

class Slider {
  Slider({
    this.image,
  });

  final String? image;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image == null ? null : image,
      };
}