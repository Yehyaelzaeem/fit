class CheerfulSocialsResponse {
  int? code;
  bool? success;
  List<CheerfulData>? data;

  CheerfulSocialsResponse({this.code, this.success, this.data});

  CheerfulSocialsResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    if (json['data'] != null) {
      data = <CheerfulData>[];
      json['data'].forEach((v) { data!.add(new CheerfulData.fromJson(v)); });
    }  }

}

class CheerfulData {
  String? image;
  String? link;

  CheerfulData({this.image, this.link});

  CheerfulData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    link = json['link'];
  }
}
