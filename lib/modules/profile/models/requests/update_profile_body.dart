import 'dart:io';

class UpdateProfileBody {
  String? name;
  String? phone;
  String? email;
  File? avatar;
  // String? gender;
  // String? birthDate;

  void copyWith({
    String? name,
    String? phone,
    String? email,
    File? avatar,
    // String? gender,
    // String? birthDate,
  }) {
    this.name = name ?? this.name;
    this.phone = phone ?? this.phone;
    this.email = email ?? this.email;
    this.avatar = avatar ?? this.avatar;
    // this.gender = birthDate ?? this.gender;
    // this.birthDate = birthDate ?? this.birthDate;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "avatar": avatar,
      // "gender": gender,
      // "birth_date": birthDate,
    };
  }
}
