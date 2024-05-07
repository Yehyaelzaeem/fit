class ServicesResponse {
  int? code;
  bool? success;
  List<Data>? data;

  ServicesResponse({this.code, this.success, this.data});

  ServicesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Data {
  int? id;
  String? name;
  String? image;
  List<Packages>? packages;

  Data({this.id, this.name, this.image, this.packages});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  int? id;
  int? price;
  String? duration;
  String? currency;
  String? description;
  bool? paymentStatus;
  bool? applePayPayments;
  bool? visaPayments;

  Packages(
      {this.id,
      this.price,
      this.duration,
      this.currency,
      this.description,
      this.applePayPayments,
      this.visaPayments,
      this.paymentStatus});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    duration = json['duration'];
    currency = json['currency'];
    description = json['description'];
    paymentStatus = json['payment_status'];
    applePayPayments = json['applepay_payments'];
    visaPayments = json['visa_payments'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['payment_status'] = this.paymentStatus;
    data['applepay_payments'] = this.applePayPayments;
    data['visa_payments'] = this.visaPayments;

    return data;
  }
}
