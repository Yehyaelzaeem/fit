
class PrivacyPolicyModel {
  String title;
  String text;
  String image;

  PrivacyPolicyModel({
    required this.title,
    required this.text,
    required this.image,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) => PrivacyPolicyModel(
    title: json["title"],
    text: json["text"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "text": text,
    "image": image,
  };
}
