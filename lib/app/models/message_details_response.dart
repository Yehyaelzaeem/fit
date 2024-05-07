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
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? subject;
  String? message;
  String? date;
  bool? hasPlan;
  String? planUrl;

  Data({this.id, this.subject, this.message, this.date, this.hasPlan, this.planUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    message = json['message'];
    date = json['date'];
    hasPlan = json['has_plans']??false;
    planUrl = json['plan_url'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['date'] = this.date;
    data['has_plans'] = this.hasPlan;
    data['plan_url'] = this.planUrl;
    return data;
  }
}
