class OrientationVideosResponse {
  int? code;
  bool? success;
  List<Data>? data;

  OrientationVideosResponse({this.code, this.success, this.data});

  OrientationVideosResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  String? name;
  String? videoUrl;
  String? image;

  Data(
      {this.id,
      this.name,
      this.videoUrl,
      this.image,});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? " ";
    videoUrl = json['video_url'];
    image = json['image'];
  }
}
