class MyPackagesResponse {
  int? code;
  bool? success;
  List<Data>? data;

  MyPackagesResponse({this.code, this.success, this.data});

  MyPackagesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
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

  Data(
      {this.id,
        this.name,
        this.package,
        this.description,
        this.price,
        this.usdPrice,
        this.time,
        this.date,
        this.paymentStatus});

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
