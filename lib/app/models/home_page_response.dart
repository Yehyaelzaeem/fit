class HomePageResponse {
  int? code;
  bool? success;
  HomeData? data;

  HomePageResponse({this.code, this.success, this.data});

  HomePageResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
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

class HomeData {
  List<Slider>? slider;
  List<Services>? services;
  bool? subscriptionStatus;

  HomeData({this.slider, this.services, this.subscriptionStatus});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['slider'] != null) {
      slider = <Slider>[];
      json['slider'].forEach((v) {
        slider!.add(new Slider.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    subscriptionStatus = json['subscribtion_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slider {
  int? id;
  String? image;

  Slider({this.id, this.image});

  Slider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class Services {
  int? id;
  String? title;
  List<Items>? items;

  Services({this.id, this.title, this.items});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? title;
  String? text;
  String? link;
  bool? hasOrientation;
  String? image;
  Cover? cover;

  Items({this.hasOrientation, this.id, this.title, this.text, this.link, this.image, this.cover});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    text = json['text'];
    link = json['link'];
    image = json['image'];
    cover = json['cover'] != null ? new Cover.fromJson(json['cover']) : null;
    hasOrientation = json['has_orientation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['text'] = this.text;
    data['link'] = this.link;
    data['image'] = this.image;
    data['has_orientation'] = this.hasOrientation;
    if (this.cover != null) {
      data['cover'] = this.cover!.toJson();
    }
    return data;
  }
}

class Cover {
  String? type;
  String? content;

  Cover({this.type, this.content});

  Cover.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['content'] = this.content;
    return data;
  }
}
