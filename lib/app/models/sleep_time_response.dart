class SleepTimeResponse {
  int? code;
  bool? success;
  String? message;

  SleepTimeResponse({this.code, this.success, this.message});

  SleepTimeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
  }
}
