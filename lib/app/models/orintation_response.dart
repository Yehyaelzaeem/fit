class OrintationResponse {
  int? code;
  bool? success;
  Data? data;

  OrintationResponse({this.code, this.success, this.data});

  OrintationResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  String? intro;
  List<Targets>? targets;
  List<Targets>? hearingFrom;

  Data({this.intro, this.targets, this.hearingFrom});

  Data.fromJson(Map<String, dynamic> json) {
    intro = json['intro'];
    if (json['targets'] != null) {
      targets = <Targets>[];
      json['targets'].forEach((v) {
        targets!.add(new Targets.fromJson(v));
      });
    }
    if (json['hearing_from'] != null) {
      hearingFrom = <Targets>[];
      json['hearing_from'].forEach((v) {
        hearingFrom!.add(new Targets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intro'] = this.intro;
    if (this.targets != null) {
      data['targets'] = this.targets!.map((v) => v.toJson()).toList();
    }
    if (this.hearingFrom != null) {
      data['hearing_from'] = this.hearingFrom!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Targets {
  int? id;
  String? title;
  bool? isSellected;

  Targets({this.id, this.title, this.isSellected});

  Targets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isSellected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
