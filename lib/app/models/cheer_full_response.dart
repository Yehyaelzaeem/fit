// To parse this JSON data, do
//
//     final cheerFullResponse = cheerFullResponseFromJson(jsonString);

import 'dart:convert';

CheerFullResponse cheerFullResponseFromJson(String str) => CheerFullResponse.fromJson(json.decode(str));

class CheerFullResponse {
  CheerFullResponse({
    this.code,
    this.success,
    this.data,
  });

  int? code;
  bool? success;
  Data? data;

  factory CheerFullResponse.fromJson(Map<String, dynamic> json) => CheerFullResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.isActive,
  });

  bool? isActive;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isActive: json["is_active"] == null ? null : json["is_active"],
      );
}
