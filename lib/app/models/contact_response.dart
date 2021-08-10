class ContactResponse {
  int? code;
  bool? success;
  Data? data;

  ContactResponse({this.code, this.success, this.data});

  ContactResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

}

class Data {
  ContactInfo? contactInfo;
  List<SocialMedia>? socialMedia;

  Data({this.contactInfo, this.socialMedia});

  Data.fromJson(Map<String, dynamic> json) {
    contactInfo = json['contact_info'] != null
        ? new ContactInfo.fromJson(json['contact_info'])
        : null;
    if (json['social_media'] != null) {
      socialMedia =  <SocialMedia>[];
      json['social_media'].forEach((v) {
        socialMedia!.add(new SocialMedia.fromJson(v));
      });
    }
  }

}

class ContactInfo {
  String? phone;
  String? email;
  String? address;
  String? workingHours;

  ContactInfo({this.phone, this.email, this.address, this.workingHours});

  ContactInfo.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    workingHours = json['working_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['working_hours'] = this.workingHours;
    return data;
  }
}

class SocialMedia {
  String? image;
  String? link;

  SocialMedia({this.image, this.link});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['link'] = this.link;
    return data;
  }
}
