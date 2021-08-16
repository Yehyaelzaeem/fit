class SessionResponse {
  int? code;
  bool? success;
  List<Data>? data;

  SessionResponse({this.code, this.success, this.data});

  SessionResponse.fromJson(Map<String, dynamic> json) {
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

  String? day;

  String? date;
  String? status;
  bool? detailsStatus;

  Data({this.id, this.date, this.day, this.status, this.detailsStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day']??" ";
    date = json['date'];
    status = json['status'];
    detailsStatus = json['details_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['status'] = this.status;
    data['details_status'] = this.detailsStatus;
    return data;
  }
}
