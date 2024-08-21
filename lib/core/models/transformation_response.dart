class TransformationsResponse {
  int? code;
  bool? success;
  List<Data>? data;

  TransformationsResponse({this.code, this.success, this.data});

  TransformationsResponse.fromJson(Map<String, dynamic> json) {
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
  String? date;
  String? type;
  String? content;

  Data({this.id, this.date, this.type, this.content});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['type'] = this.type;
    data['content'] = this.content;
    return data;
  }
}
