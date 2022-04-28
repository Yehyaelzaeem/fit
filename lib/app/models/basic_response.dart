// To parse this JSON data, do
//
//     final basicResponse = basicResponseFromJson(jsonString);

import 'dart:convert';

BasicResponse basicResponseFromJson(String str) => BasicResponse.fromJson(json.decode(str));

String basicResponseToJson(BasicResponse data) => json.encode(data.toJson());

class BasicResponse {
  BasicResponse({
    this.code,
    this.success,
    this.message,
  });

  final int? code;
  final bool? success;
  final String? message;

  factory BasicResponse.fromJson(Map<String, dynamic> json) => BasicResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
