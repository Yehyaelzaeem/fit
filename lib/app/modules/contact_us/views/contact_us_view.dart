import 'package:app/app/utils/styles/app_text_theme.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:flutter/material.dart';

import '../controllers/contact_us_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends GetView<ContactUsController> {
  final _contactFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        title: Text(Strings().contactUs),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              contactFormView(),
            ],
          ),
        );
      }),
    );
  }

  Widget contactFormView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Form(
        key: _contactFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //first name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: EditText(
                  type: TextInputType.name,
                  iconData: Icons.person,
                  validateFunc: (text) {
                    controller.contactFirstName.value = text;
                    return text.length > 1 ? null : Strings().nameErrorLengthTooShort;
                  },
                  updateFunc: (text) {
                    controller.contactFirstName.value = text;
                  },
                  value: controller.contactFirstName.value,
                  hint: Strings().firstName,
                ),
              ),
              //last name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: EditText(
                  type: TextInputType.name,
                  iconData: Icons.person,
                  validateFunc: (text) {
                    controller.contactLastName.value = text;
                    return text.length > 1 ? null : '';
                  },
                  updateFunc: (text) {
                    controller.contactLastName.value = text;
                  },
                  value: controller.contactLastName.value,
                  hint: Strings().lastName,
                ),
              ),
              //email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: EditText(
                  type: TextInputType.emailAddress,
                  iconData: Icons.email,
                  validateFunc: (text) {
                    controller.contactEmail.value = text;
                    return text.length > 1 ? null : Strings().emailNotValid;
                  },
                  updateFunc: (text) {
                    controller.contactEmail.value = text;
                  },
                  value: controller.contactEmail.value,
                  hint: Strings().email,
                ),
              ),
              //phone
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: EditText(
                  type: TextInputType.phone,
                  iconData: Icons.phone_iphone,
                  validateFunc: (text) {
                    String phone = text;
                    controller.contactPhone.value = text;
                    return phone.length >= 8 ? null : '';
                  },
                  updateFunc: (text) {
                    controller.contactPhone.value = text;
                  },
                  value: controller.contactPhone.value,
                  hint: Strings().phone,
                ),
              ),
              //message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: EditText(
                  type: TextInputType.text,
                  iconData: Icons.text_fields,
                  lines: 2,
                  validateFunc: (text) {
                    String phone = text;
                    controller.contactMessage.value = text;
                    return phone.length > 2 ? null : '';
                  },
                  updateFunc: (text) {
                    controller.contactMessage.value = text;
                  },
                  value: controller.contactMessage.value,
                  hint: 'Message',
                ),
              ),
              SizedBox(height: 4),
              Obx(
                () => Container(
                    decoration: kButtonPrimaryStyle,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: TextButton(
                      onPressed: () {},
                      child: controller.contactLoading.value
                          ? Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 1.5,
                            )))
                          : Text(
                              Strings().send,
                              style: TextStyle(color: Colors.white),
                            ),
                    )),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
