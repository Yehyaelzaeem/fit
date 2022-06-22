// To parse this JSON data, do
//
//     final versionResponse = versionResponseFromJson(jsonString);

import 'dart:convert';

VersionResponse versionResponseFromJson(String str) => VersionResponse.fromJson(json.decode(str));

class VersionResponse {
  VersionResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.forceUpdate,
  });

  bool success;
  int code;
  String message;
  bool forceUpdate;

  factory VersionResponse.fromJson(Map<String, dynamic> json) => VersionResponse(
        success: json["success"] ?? "",
        code: json["code"] ?? "",
        message: json["message"] ?? "",
        forceUpdate: json["force_update"] ?? false,
      );
}
