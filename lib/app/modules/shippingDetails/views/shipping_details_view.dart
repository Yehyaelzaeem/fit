import 'package:app/app/modules/shippingDetails/views/pick_map.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/shipping_details_controller.dart';

class ShippingDetailsView extends GetView<ShippingDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Obx(
          () => Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: controller.key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    appBar(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //First name
                          Row(
                            children: [
                              Icon(Icons.person, color: kColorPrimary),
                              kTextbody('Full Name', size: 18, bold: true),
                            ],
                          ),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: EditText(
                              value: controller.name.value,
                              hint: '',
                              radius: 4,
                              noBorder: true,
                              background: Color(0xffeeeeee),
                              updateFunc: (String text) {
                                controller.name.value = text;
                              },
                              validateFunc: (text) {
                                if (text.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              type: TextInputType.name,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),

                    //* Email
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.email, color: kColorPrimary),
                                    kTextbody('Email', size: 18, bold: true),
                                  ],
                                ),
                                Container(
                                  color: Color(0xffeeeeee),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: EditText(
                                    value: controller.email.value,
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {
                                      controller.email.value = text;
                                    },
                                    validateFunc: (text) {
                                      if (!GetUtils.isEmail(text)) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.emailAddress,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //* Mobile Number
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.phone_iphone, color: kColorPrimary),
                                    kTextbody('Mobile Number', size: 18, bold: true),
                                  ],
                                ),
                                Container(
                                  color: Color(0xffeeeeee),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: EditText(
                                    value: controller.phone.value,
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {
                                      controller.phone.value = text;
                                    },
                                    validateFunc: (text) {
                                      if (text.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.number,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //* DetailedAddress
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.location_city, color: kColorPrimary),
                                    kTextbody('Detailed delivery address', size: 18, bold: true),
                                  ],
                                ),
                                Container(
                                  color: Color(0xffeeeeee),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: EditText(
                                    value: controller.detailedAddress.value,
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {
                                      controller.detailedAddress.value = text;
                                    },
                                    validateFunc: (text) {
                                      if (text.isEmpty) {
                                        return 'Please enter your address';
                                      }
                                      return null;
                                    },
                                    type: TextInputType.text,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //* Location
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //First name
                                Row(
                                  children: [
                                    Icon(Icons.gps_fixed, color: kColorPrimary),
                                    kTextbody('Current location', size: 18, bold: true),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (controller.mapLoading.value == true) return;
                                    controller.mapLoading.value = true;
                                    await controller.requestPermission();
                                    Get.dialog(PickMap());
                                    controller.mapLoading.value = false;
                                  },
                                  child: Container(
                                    color: Color(0xffeeeeee),
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    width: Get.width,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        if (controller.textController.text.isEmpty && controller.latitude.value.isNotEmpty) kTextbody("${controller.latitude.value}, ${controller.longitude.value}"),
                                        if (controller.textController.text.isNotEmpty) kTextbody("${controller.textController.text}"),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          kButtonDefault(
                            'Submit',
                            marginH: MediaQuery.of(context).size.width / 4,
                            paddingV: 0,
                            func: () {
                              if (!controller.key.currentState!.validate()) {
                                return;
                              } else {
                                controller.submit();
                              }
                            },
                            shadow: true,
                            paddingH: 16,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.width / 14),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: MediaQuery.of(Get.context!).size.width,
      height: 65,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          blurRadius: 2,
          spreadRadius: 2,
          offset: Offset(0, 0),
        ),
      ]),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              kLogoChellFullRow,
              height: 80,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
