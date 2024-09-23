class RegistrationBody {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirmation;

  void copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.phone = phone ?? this.phone;
    this.password = password ?? this.password;
    this.passwordConfirmation = passwordConfirmation ?? this.passwordConfirmation;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}
