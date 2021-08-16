class MessagesResponse {
  int? code;
  List<Data>? data;
  bool? success;

  MessagesResponse({this.code, this.data, this.success});

  MessagesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  int? id;
  String? subject;
  bool? viewStatus;
  String? date;

  Data({this.id, this.subject, this.viewStatus, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    viewStatus = json['view_status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['view_status'] = this.viewStatus;
    data['date'] = this.date;
    return data;
  }
}
