import 'package:app/app/models/contact_response.dart';
import 'package:app/app/models/general_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContactUsController extends GetxController {
  final contactResponse = ContactResponse().obs;

  TextEditingController  contactEmail = new TextEditingController();
  TextEditingController contactFirstName = new TextEditingController();
  TextEditingController contactPhone =  new TextEditingController();
  TextEditingController subject =  new TextEditingController();
  TextEditingController  contactMessage =  new TextEditingController();
  bool contactLoading = false;

  @override
  void onInit() async {
    contactResponse.value = await ApiProvider().getContactData();
    super.onInit();
  }

  void sendMessage() async {
    print(contactFirstName.text);
    print(contactEmail.text);
    print(contactPhone.text);
    print(subject.text);
    print(contactPhone.text);
    await ApiProvider()
        .sendContactData(contactFirstName.text, contactEmail.text, contactPhone.text, subject.text,
            contactMessage.text)
        .then((value) {
      if (value.success == true) {
        Get.offAllNamed(Routes.HOME);
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
