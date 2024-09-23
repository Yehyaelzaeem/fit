
class TermsConditionsModels {
  String title;
  String text;
  String image;

  TermsConditionsModels({
    required this.title,
    required this.text,
    required this.image,
  });

  factory TermsConditionsModels.fromJson(Map<String, dynamic> json) => TermsConditionsModels(
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
