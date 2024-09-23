class NotificationModel {
  int? id;
  String? nameEn;
  String? nameAr;
  String? contentEn;
  String? contentAr;
  String? link;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.id,
      this.nameEn,
      this.nameAr,
      this.contentEn,
      this.contentAr,
      this.link,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
    contentEn = json['content_en'];
    contentAr = json['content_ar'];
    link = json['link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_en'] = nameEn;
    data['name_ar'] = nameAr;
    data['content_en'] = contentEn;
    data['content_ar'] = contentAr;
    data['link'] = link;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
