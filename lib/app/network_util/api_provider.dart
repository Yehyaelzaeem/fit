import 'package:app/app/models/about_response.dart';
import 'package:app/app/models/contact_response.dart';
import 'package:app/app/models/faq_response.dart';
import 'package:app/app/models/general_response.dart';
import 'package:app/app/models/home_page_response.dart';
import 'package:app/app/models/message_details_response.dart';
import 'package:app/app/models/messages_response.dart';
import 'package:app/app/models/orintation_response.dart';
import 'package:app/app/models/session_response.dart';
import 'package:app/app/models/sessions_details_response.dart';
import 'package:app/app/models/transformation_response.dart';
import 'package:app/app/models/user_response.dart';
import 'package:app/app/network_util/network.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  NetworkUtil _utils = new NetworkUtil();

  Future<HomePageResponse> getHomeData() async {
    Response response = await _utils.get("home");
    if (response.statusCode == 200) {
      return HomePageResponse.fromJson(response.data);
    } else {
      return HomePageResponse.fromJson(response.data);
    }
  }

  Future<MessagesResponse> getMessagesData() async {
    Response response = await _utils.get("messages");
    if (response.statusCode == 200) {
      return MessagesResponse.fromJson(response.data);
    } else {
      return MessagesResponse.fromJson(response.data);
    }
  }

  Future<TransformationsResponse> getTransformationData() async {
    Response response = await _utils.get("transformations");
    if (response.statusCode == 200) {
      return TransformationsResponse.fromJson(response.data);
    } else {
      return TransformationsResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> deleteMessage(int id) async {
    FormData body = FormData.fromMap({
      'delete': id,
    });
    Response response = await _utils.post("delete_message", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<MessageDetailsResponse> getMessagesDetailsData(int id) async {
    Response response = await _utils.get("message/$id");
    if (response.statusCode == 200) {
      return MessageDetailsResponse.fromJson(response.data);
    } else {
      return MessageDetailsResponse.fromJson(response.data);
    }
  }

  Future<AboutResponse> getAboutData() async {
    Response response = await _utils.get("about");
    if (response.statusCode == 200) {
      return AboutResponse.fromJson(response.data);
    } else {
      return AboutResponse.fromJson(response.data);
    }
  }

  Future<ContactResponse> getContactData() async {
    Response response = await _utils.get("contact");
    if (response.statusCode == 200) {
      return ContactResponse.fromJson(response.data);
    } else {
      return ContactResponse.fromJson(response.data);
    }
  }

  Future<OrintationResponse> getOritationSelletionsData() async {
    Response response = await _utils.get("orientation_settings");
    if (response.statusCode == 200) {
      return OrintationResponse.fromJson(response.data);
    } else {
      return OrintationResponse.fromJson(response.data);
    }
  }

  Future<FaqResponse> getFaqtData() async {
    Response response = await _utils.get("faq");
    if (response.statusCode == 200) {
      return FaqResponse.fromJson(response.data);
    } else {
      return FaqResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> sendContactData(
      String name, String email, String phone, String subject, String message) async {
    FormData body = FormData.fromMap(
        {'name': name, 'email': email, 'phone': phone, 'subject': subject, 'message': message});
    Response response = await _utils.post("contact_form", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<UserResponse> login(String id, String password) async {
    FormData body = FormData.fromMap({'patient_id': id, 'password': password});
    Response response = await _utils.post("login", body: body);
    if (response.data["success"] == true) {
      return UserResponse.fromJson(response.data);
    } else {
      return UserResponse.fromJson(response.data);
    }
  }

  Future<UserResponse> getProfile() async {
    Response response = await _utils.get("profile");
    if (response.data["success"] == true) {
      return UserResponse.fromJson(response.data);
    } else {
      return UserResponse.fromJson(response.data);
    }
  }

  Future<SessionResponse> getSessions() async {
    Response response = await _utils.get("sessions");
    if (response.data["success"] == true) {
      return SessionResponse.fromJson(response.data);
    } else {
      return SessionResponse.fromJson(response.data);
    }
  }

  Future<SessionDetailsResponse> getSessionDetails(int? id) async {
    Response response = await _utils.get("session/$id");
    if (response.data["success"] == true) {
      return SessionDetailsResponse.fromJson(response.data);
    } else {
      return SessionDetailsResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> signUpApi(String id, String password, String name, String email,
      String date, String phone, String password_confirmation) async {
    FormData body = FormData.fromMap({
      "patient_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "date_of_birth": date,
      "password": password,
      "password_confirmation": password_confirmation
    });
    Response response = await _utils.post("register", body: body);
    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }

  Future<GeneralResponse> sendOrintaionData(
      {String? first_name,
      String? middle_name,
      String? last_name,
      String? mobile,
      String? age,
      String? country,
      int? hear_from,
      int? target}) async {
    FormData body = FormData.fromMap({
      "first_name": first_name,
      "middle_name": middle_name,
      "last_name": last_name,
      "mobile": mobile,
      "age": age,
      "target": target,
      "country": country,
      "hear_from": hear_from
    });
    Response response = await _utils.post(
      "orientation_registeration",
      body: body,
    );

    if (response.data["success"] == true) {
      return GeneralResponse.fromJson(response.data);
    } else {
      return GeneralResponse.fromJson(response.data);
    }
  }
}
