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
  String? name;
  String? videoUrl;
  String? image;

  Data({
    this.id,
    this.name,
    this.videoUrl,
    this.image,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? " ";
    videoUrl = json['video_url'];
    image = json['image'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['video_url'] = this.videoUrl;
    data['image'] = this.image;
    return data;
  }
}
