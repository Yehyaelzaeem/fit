class PackageDetailsResponse {
  int? code;
  bool? success;
  String? message;
  Data? data;

  PackageDetailsResponse({this.code, this.success, this.message, this.data});

  PackageDetailsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? name;
  String? package;
  String? description;
  int? price;
  int? usdPrice;
  String? time;
  String? date;
  String? paymentStatus;

  Data({
    this.id,
    this.name,
    this.package,
    this.description,
    this.price,
    this.usdPrice,
    this.time,
    this.date,
    this.paymentStatus,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    package = json['package'];
    description = json['description'];
    price = json['price'];
    usdPrice = json['usd_price'];
    time = json['time'];
    date = json['date'];
    paymentStatus = json['payment_status'];
  }
}
