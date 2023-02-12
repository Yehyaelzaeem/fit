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
}

class Data {
  int? id;
  String? subject;
  String? message;
  String? date;
  bool? hasPlan;

  Data({this.id, this.subject, this.message, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    message = json['message'];
    date = json['date'];
    hasPlan = json['has_plan']??false;
  }
}
