import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/orientation_register_controller.dart';

class OrientationRegisterView extends GetView<OrientationRegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        title: Text('Prientation Registration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[300],
              width: double.infinity,
              child: kTextbody(Strings().longText, align: TextAlign.start),
            ),
            Container(
              color: Colors.white,
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                  SizedBox(height: 12),
                  EditText(value: '', hint: Strings().firstName, type: TextInputType.name),
                  SizedBox(height: 8),
                  EditText(value: '', hint: 'Middle name', type: TextInputType.name),
                  SizedBox(height: 8),
                  EditText(value: '', hint: Strings().lastName, type: TextInputType.name),
                  SizedBox(height: 8),
                  EditText(value: '', hint: 'Mobile number', type: TextInputType.phone),
                  SizedBox(height: 8),
                  EditText(value: '', hint: 'age', type: TextInputType.number),
                  SizedBox(height: 8),

                  Container(
                      width: double.infinity, child: kTextHeader('What is your target?', size: 18, align: TextAlign.start)),
                  RadioListTile(
                    value: 'Select 1',
                    groupValue: '12',
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: kTextHeader('Select 1', align: TextAlign.start, paddingH: 0),
                    onChanged: (value) {},
                  ),
                  RadioListTile(
                    value: 'Select 2',
                    groupValue: '12',
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: kTextHeader('Select 1', align: TextAlign.start, paddingH: 0),
                    onChanged: (value) {},
                  ),
                  RadioListTile(
                    value: 'Select 3',
                    groupValue: '12',
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: kTextHeader('Select 1', align: TextAlign.start, paddingH: 0),
                    onChanged: (value) {},
                  ),

                  Container(
                      width: double.infinity, child: kTextHeader('What is your country?', size: 18, align: TextAlign.start)),
                  EditText(value: '', hint: '', type: TextInputType.name),
                  SizedBox(height: 8),
                  Container(
                      width: double.infinity,
                      child: kTextHeader('Where did you hear about us?', size: 18, align: TextAlign.start)),
                  SizedBox(height: 8),
                  Wrap(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                        child: Chip(label: kTextbody('Google'),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                        child: Chip(label: kTextbody('Google'),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                        child: Chip(label: kTextbody('Google'),padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),)),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Chip(
                            label: kTextbody('Google'),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Chip(
                            label: kTextbody('Google'),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          )),
                    ],
                  ),

                  SizedBox(height: 4),

                  kButtonDefault(
                    'Done',
                    fullWidth: true,
                    paddingV: 0,
                    marginH: Get.width / 10,
                    func: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
