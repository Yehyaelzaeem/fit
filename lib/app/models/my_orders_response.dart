import 'dart:convert';

MyOrdersResponse myOrdersResponseFromJson(String str) => MyOrdersResponse.fromJson(json.decode(str));

class MyOrdersResponse {
  MyOrdersResponse({
    required this.code,
    required this.success,
    required this.data,
  });

  int code;
  bool success;
  Data? data;

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) => MyOrdersResponse(
        code: json["code"] == null ? null : json["code"],
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.pending,
    required this.completed,
  });

  List<Completed> pending;
  List<Completed> completed;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pending: json["pending"] == null ? [] : List<Completed>.from(json["pending"].map((x) => Completed.fromJson(x))),
        completed: json["completed"] == null ? [] : List<Completed>.from(json["completed"].map((x) => Completed.fromJson(x))),
      );
}

class Completed {
  Completed({
    required this.id,
    required this.price,
    required this.status,
    required this.deliveryMethod,
    required this.visaPaymentStatus,
    required this.userInfo,
    required this.note,
    required this.meals,
    required this.date,
    required this.paymentUrl,
  });

  int id;
  double price;
  String status;
  String deliveryMethod;
  bool visaPaymentStatus;
  UserInfo? userInfo;
  String note;
  String date;
  String paymentUrl;
  List<Meal> meals;

  factory Completed.fromJson(Map<String, dynamic> json) => Completed(
        id: json["id"] == null ? null : json["id"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        date: json["date"] == null ? null : json["date"],
        status: json["status"] == null ? null : json["status"],
        deliveryMethod: json["delivery_method"] == null ? null : json["delivery_method"],
    visaPaymentStatus: json["visa_payment_status"] == null ? null : json["visa_payment_status"],
        userInfo: json["user_info"] == null ? null : UserInfo.fromJson(json["user_info"]),
        note: json["note"] == null ? '' : json["note"],
    paymentUrl: json["payment_url"] == null ? '' : json["payment_url"],
        meals: json["meals"] == null ? [] : List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      );
}

class Meal {
  Meal({
    required this.id,
    required this.name,
    required this.price,
  });

  int id;
  String name;
  double price;

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"].toDouble(),
      );
}

class UserInfo {
  UserInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  String name;
  String email;
  String phone;
  String address;
  String? latitude;
  String? longitude;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        name: json["name"] == null ? '' : json["name"],
        email: json["email"] == null ? '' : json["email"],
        phone: json["phone"] == null ? '' : json["phone"],
        address: json["address"] == null ? '' : json["address"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
      );
}
