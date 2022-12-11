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

}

class Packages {
  int? id;
  int? price;
  String? duration;
  String? currency;
  String? description;
  bool? paymentStatus;

  Packages({this.id, this.price, this.duration,this.currency, this.description, this.paymentStatus});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    duration = json['duration'];
    currency = json['currency'];
    description = json['description'];
    paymentStatus = json['payment_status'];
  }

}