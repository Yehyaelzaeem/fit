class CartOrderResponse {
  int? code;
  bool? success;
  Data? data;
  String? paymentUrl;

  CartOrderResponse({this.code, this.success, this.data, this.paymentUrl});

  CartOrderResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    paymentUrl = json['payment_url'];
  }
}

class Data {
  int? id;
  int? price;
  String? status;
  String? deliveryMethod;
  String? payMethod;
  bool? visaPaymentStatus;
  String? date;
  UserInfo? userInfo;
  List<Meals>? meals;

  Data(
      {this.id,
      this.price,
      this.status,
      this.deliveryMethod,
      this.payMethod,
      this.visaPaymentStatus,
      this.date,
      this.userInfo,
      this.meals});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    status = json['status'];
    deliveryMethod = json['delivery_method'];
    payMethod = json['pay_method'];
    visaPaymentStatus = json['visa_payment_status'];
    date = json['date'];
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
        : null;
    if (json['meals'] != null) {
      meals = <Meals>[];
      json['meals'].forEach((v) {
        meals!.add(new Meals.fromJson(v));
      });
    }
  }
}

class UserInfo {
  String? name;
  String? email;
  String? phone;
  String? address;
  String? latitude;
  String? longitude;

  UserInfo(
      {this.name,
      this.email,
      this.phone,
      this.address,
      this.latitude,
      this.longitude});

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class Meals {
  int? id;
  String? name;
  int? price;

  Meals({
    this.id,
    this.name,
    this.price,
  });

  Meals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }
}
