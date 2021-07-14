import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/orientation_register_controller.dart';

class OrientationRegisterView extends GetView<OrientationRegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              HomeAppbar(),
              SizedBox(height: 12),
              Container(
                alignment: Alignment(0.01, -1.0),
                height: 30.0,
                width: Get.width / 1.6,
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(15.0),
                  ),
                  color: const Color(0xFF414042),
                ),
                child: Center(
                  child: Text(
                    'Orientation Registration',
                    style: GoogleFonts.cairo(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[300],
                width: double.infinity,
                child: kTextbody(Strings().longText, align: TextAlign.start),
              ),
              Container(
                color: Colors.white,
                width: Get.width,
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
                          kTextbody('First Name', size: 18, bold: true),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                //SizedBox(width: 20),
                                // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: EditText(
                                    value: '',
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {},
                                    validateFunc: (text) {},
                                    type: TextInputType.name,
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          //Middle Name
                          kTextbody('Middle Name', size: 18, bold: true),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                //SizedBox(width: 20),
                                // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: EditText(
                                    value: '',
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {},
                                    validateFunc: (text) {},
                                    type: TextInputType.name,
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          //Last name
                          kTextbody('Last Name', size: 18, bold: true),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                //SizedBox(width: 20),
                                // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: EditText(
                                    value: '',
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {},
                                    validateFunc: (text) {},
                                    type: TextInputType.name,
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          //First name
                          kTextbody('Mobile Number', size: 18, bold: true),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                //SizedBox(width: 20),
                                // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: EditText(
                                    value: '',
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {},
                                    validateFunc: (text) {},
                                    type: TextInputType.phone,
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),
                          //Age
                          kTextbody('Age', size: 18, bold: true),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                // SizedBox(width: 20),
                                // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: EditText(
                                    value: '',
                                    hint: '',
                                    contentPaddingH: 0,
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {},
                                    validateFunc: (text) {},
                                    type: TextInputType.number,
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),
                          kTextbody('What is your target?', size: 18, bold: true),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectedTarget.value = 'Weight loss (ideal weight and ideal shape)';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Weight loss (ideal weight and ideal shape)', activeColor: kColorPrimary, groupValue: controller.selectedTarget.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Weight loss (ideal weight and ideal shape)', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedTarget.value = 'Reshaping (fat burning and muscle gaining)';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Reshaping (fat burning and muscle gaining)', activeColor: kColorPrimary, groupValue: controller.selectedTarget.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Reshaping (fat burning and muscle gaining)', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedTarget.value = 'Weight gain (ideal weight and ideal shape)';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Weight gain (ideal weight and ideal shape)', activeColor: kColorPrimary, groupValue: controller.selectedTarget.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Weight gain (ideal weight and ideal shape)', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedTarget.value = 'Increase fitness level';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Increase fitness level', activeColor: kColorPrimary, groupValue: controller.selectedTarget.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Increase fitness level', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedTarget.value = 'Healthy lifetsyle';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Healthy lifetsyle', activeColor: kColorPrimary, groupValue: controller.selectedTarget.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Healthy lifetsyle', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedTarget.value = 'Other';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Other', activeColor: kColorPrimary, groupValue: controller.selectedTarget.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Other', bold: true, size: 14)],
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Age
                          SizedBox(height: 8),
                          kTextbody('What is your country?', size: 18, bold: true),
                          Container(
                            color: Color(0xffeeeeee),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                //SizedBox(width: 20),
                                // Container(height: 30, width: 1, color: Color(0xFF666565)),
                                SizedBox(width: 4),
                                Expanded(
                                  child: EditText(
                                    value: '',
                                    hint: '',
                                    radius: 4,
                                    noBorder: true,
                                    background: Color(0xffeeeeee),
                                    updateFunc: (text) {},
                                    validateFunc: (text) {},
                                    type: TextInputType.name,
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          kTextbody('Where did you hear about us?', size: 18, bold: true),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedSocial.value = 'Facebook';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Facebook', activeColor: kColorPrimary, groupValue: controller.selectedSocial.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Facebook', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedSocial.value = 'Instagram';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Instagram', activeColor: kColorPrimary, groupValue: controller.selectedSocial.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Instagram', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedSocial.value = 'Family / Friends';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Family / Friends', activeColor: kColorPrimary, groupValue: controller.selectedSocial.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Family / Friends', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        controller.selectedSocial.value = 'Other';
                      },
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffeeeeee),
                        child: Row(
                          children: [Radio(value: 'Other', activeColor: kColorPrimary, groupValue: controller.selectedSocial.value, onChanged: (value) {}), SizedBox(width: 4), kTextbody('Other', bold: true, size: 14)],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    SizedBox(height: 4),

                    Center(
                      child: kButtonDefault(
                        'Done',
                        paddingV: 0,
                        paddingH: 40,
                        marginH: Get.width / 10,
                        func: () {},
                        shadow: true,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
