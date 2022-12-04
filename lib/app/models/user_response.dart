class UserResponse {
  int? code;
  Data? data;
  bool? success;
  String? message;

  UserResponse({this.code, this.data, this.success, this.message});

  UserResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? patientId;
  String? name;
  String? email;
  String? phone;
  String? dateOfBirth;
  String? gender;
  String? packageRenewalDate;
  NextSession? nextSession;
  Target? target;
  LastBodyComposition? lastBodyComposition;
  String? image;
  int? newMessages;
  String? accessToken;
  bool? showDeleteAccount;

  Data({
    this.id,
    this.patientId,
    this.name,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.packageRenewalDate,
    this.nextSession,
    this.target,
    this.lastBodyComposition,
    this.image,
    this.newMessages,
    this.showDeleteAccount,
    this.accessToken,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    name = json['name'] ?? "Enter your Name ";
    email = json['email'] ?? "Enter your Email ";
    phone = json['phone'] ?? " Enter your Phone";
    dateOfBirth = json['date_of_birth'] ?? " Enter your Date Of Birth";
    gender = json['gender'] ?? " Select Gender";
    packageRenewalDate = json['package_renewal_date'] ?? "";
    nextSession = json['next_session'] != null ? new NextSession.fromJson(json['next_session']) : null;
    target = json['target'] != null ? new Target.fromJson(json['target']) : null;
    lastBodyComposition = json['last_body_composition'] != null ? new LastBodyComposition.fromJson(json['last_body_composition']) : null;
    image = json['image'];
    newMessages = json['new_messages'];
    accessToken = json['access_token'];
    showDeleteAccount = json['account_delete_btn'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['package_renewal_date'] = this.packageRenewalDate;
    if (this.nextSession != null) {
      data['next_session'] = this.nextSession!.toJson();
    }
    if (this.target != null) {
      data['target'] = this.target!.toJson();
    }
    if (this.lastBodyComposition != null) {
      data['last_body_composition'] = this.lastBodyComposition!.toJson();
    }
    data['image'] = this.image;
    data['new_messages'] = this.newMessages;
    data['access_token'] = this.accessToken;
    return data;
  }
}

class NextSession {
  String? status;
  String? day;
  String? sessionDate;

  NextSession({this.status, this.day, this.sessionDate});

  NextSession.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    day = json['day'];
    sessionDate = json['session_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['day'] = this.day;
    data['session_date'] = this.sessionDate;
    return data;
  }
}

class Target {
  String? totalWeight;
  String? fats;
  String? muscles;
  String? water;

  Target({this.totalWeight, this.fats, this.muscles, this.water});

  Target.fromJson(Map<String, dynamic> json) {
    totalWeight = json['total_weight'] ?? "unknown";
    fats = json['fats'] ?? "unknown";
    muscles = json['muscles'] ?? "unknown";
    water = json['water'] ?? "unknown";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_weight'] = this.totalWeight;
    data['fats'] = this.fats;
    data['muscles'] = this.muscles;
    data['water'] = this.water;
    return data;
  }
}

class LastBodyComposition {
  String? date;
  String? totalWeight;
  String? fats;
  String? muscles;
  String? water;

  LastBodyComposition({this.date, this.totalWeight, this.fats, this.muscles, this.water});

  LastBodyComposition.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "unknown";
    totalWeight = json['total_weight'] ?? "unknown";
    fats = json['fats'] ?? "unknown";
    muscles = json['muscles'] ?? "unknown";
    water = json['water'] ?? "unknown";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['total_weight'] = this.totalWeight;
    data['fats'] = this.fats;
    data['muscles'] = this.muscles;
    data['water'] = this.water;
    return data;
  }
}
