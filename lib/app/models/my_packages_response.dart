class MyPackagesResponse {
  int? code;
  bool? success;
  Data? data;

  MyPackagesResponse({this.code, this.success, this.data});

  MyPackagesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Orders>? orders;
  bool? subscriptionStatus;
  bool? visaStatue;
  bool? applePayStatus;

  Data({this.orders, this.subscriptionStatus});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
    subscriptionStatus = json['subscribtion_status'];
    visaStatue = json['visa_payments'];
    applePayStatus = json['applepay_payments'];
  }
}

class Orders {
  int? id;
  String? name;
  String? package;
  String? description;
  int? price;
  int? usdPrice;
  String? time;
  String? date;
  String? paymentStatus;
  String? paymentUrl;
  bool? paymentUrlStatus;

  Orders({
    this.id,
    this.name,
    this.package,
    this.description,
    this.price,
    this.usdPrice,
    this.time,
    this.date,
    this.paymentUrl,
    this.paymentStatus,
    this.paymentUrlStatus,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    package = json['package'];
    description = json['description'];
    price = json['price'];
    time = json['time'];
    date = json['date'];
    paymentStatus = json['payment_status'];
    paymentUrl = json['payment_url'];
    paymentUrlStatus = json['payment_link_status'];
  }
}
