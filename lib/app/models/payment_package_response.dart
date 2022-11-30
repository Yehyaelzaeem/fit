class PackagePaymentResponse {
  int? code;
  bool? success;
  String? message;
  Data? data;

  PackagePaymentResponse({this.code, this.success, this.message, this.data});

  PackagePaymentResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? name;
  String? description;
  String? price;
  String? time;
  String? date;
  String? paymentUrl;

  Data(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.time,
        this.date,
        this.paymentUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    time = json['time'];
    date = json['date'];
    paymentUrl = json['payment_url'];
  }

}