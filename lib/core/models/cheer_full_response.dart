// To parse this JSON data, do
//
//     final cheerFullResponse = cheerFullResponseFromJson(jsonString);

import 'dart:convert';

CheerFullResponse cheerFullResponseFromJson(String str) =>
    CheerFullResponse.fromJson(json.decode(str));

class CheerFullResponse {
  CheerFullResponse({
    this.code,
    this.success,
    this.data,
  });

  int? code;
  bool? success;
  Data? data;

  factory CheerFullResponse.fromJson(Map<String, dynamic> json) =>
      CheerFullResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
      data['data'] = this.data!.toJson();

    return data;
  }
}

class Data {
  Data({
    this.isActive,
    this.isFaqActive,
    this.delivery_option,
    this.pickup_option,
  });

  bool? isActive;
  bool? isFaqActive;
  bool? delivery_option;
  bool? pickup_option;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isFaqActive:
            json["show_faq_page"] == null ? true : json["show_faq_page"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        delivery_option:
            json["delivery_option"] == null ? null : json["delivery_option"],
        pickup_option:
            json["pickup_option"] == null ? null : json["pickup_option"],
      );
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['show_faq_page'] = this.isFaqActive;
    data['is_active'] = this.isActive;
    data['delivery_option'] = this.delivery_option;
    data['pickup_option'] = this.pickup_option;
    return data;
  }
}
