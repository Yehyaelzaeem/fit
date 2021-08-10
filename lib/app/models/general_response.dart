class GeneralResponse {
  int? code;
  bool? success;
  String? message;

  GeneralResponse({this.code, this.success, this.message});

  GeneralResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
