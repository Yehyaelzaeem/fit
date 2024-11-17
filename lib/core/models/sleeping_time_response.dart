class SleepingTimesResponse {
  int? code;
  bool? success;
  List<Data>? data;

  SleepingTimesResponse({this.code, this.success, this.data});

  SleepingTimesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
  int id;
  String name;
  int from;
  int to;
  String image;

  Data({
    required this.id,
    required this.name,
    required this.from,
    required this.to,
    required this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    from: json["from"],
    to: json["to"],
    image: json["image"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "from": from,
    "to": to,
    "image": image,
  };
}
