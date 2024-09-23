class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String birthDate;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
    gender: json["gender"] ?? "",
    birthDate: json["birth_date"] ?? "",
  );
}