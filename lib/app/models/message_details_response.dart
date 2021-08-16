class MessageDetailsResponse {
  int? code;
  Data? data;
  bool? success;

  MessageDetailsResponse({this.code, this.data, this.success});

  MessageDetailsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  int? id;
  String? subject;
  String? message;
  String? date;

  Data({this.id, this.subject, this.message, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['date'] = this.date;
    return data;
  }
}
