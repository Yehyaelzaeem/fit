class LoginBody {
  String? user;
  String? password;

  LoginBody({
    this.user,
    this.password,
  });

  void copyWith({
    String? user,
    String? password,
  }) {
    this.user = user ?? this.user;
    this.password = password ?? this.password;
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "password": password,
    };
  }
}
