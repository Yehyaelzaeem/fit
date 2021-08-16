import 'package:app/app/modules/home/home_drawer.dart';
import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/diary_controller.dart';

class DiaryView extends GetView<DiaryController> {
  final controller = Get.find(tag: 'DiaryController');

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        drawer: HomeDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24),
              //* Title , download pdf
              Container(
                alignment: Alignment(0.01, -1.0),
                height: 50.0,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF414042),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Calories Calculator',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Image.asset('assets/img/ic_pdf.png'),
                          kTextHeader('PDF', color: Colors.white)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: kColorPrimary,
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
              //* Date
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_left,
                    color: kColorPrimary,
                    size: 28,
                  ),
                  kTextHeader('Tuesday, 15 Jun 2021', color: Colors.black, bold: true, size: 18),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: kColorPrimary,
                    size: 28,
                  ),
                ],
              ),
              SizedBox(height: 24),

              //* SelectImage
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                childAspectRatio: 1,
                key: Key('gd_${controller.listKey.value}'),
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ...controller.list.map((item) {
                    return GestureDetector(
                      onTap: () {
                        controller.list.firstWhere((element) => element.id == item.id).selected =
                            !item.selected;
                        controller.listKey.value = controller.listKey.value++;
                        controller.list.refresh();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            //*
                            Container(
                                // decoration: BoxDecoration(
                                //     border: Border.all(
                                //   color: kColorPrimary,
                                //   width: 1,
                                // )),
                                child: Image.asset(
                              item.selected ? 'assets/img/im_holder1_active.png' : item.imagePath,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            )),
                            if (item.selected)
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: kColorPrimary,
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),

              //* Proteins 01151792321 zahra
              Container(
                alignment: Alignment(0.01, -1.0),
                height: 50.0,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF414042),
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Proteins',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                          decoration: BoxDecoration(color: kColorPrimary),
                          child: Icon(
                            Icons.add,
                            color: Color(0xFF414042),
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(64),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 100,
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0088FF),
                                    borderRadius: BorderRadius.circular(64),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      kTextHeader('55 / 350', color: Colors.white),
                      SizedBox(width: 6),
                    ],
                  ),
                ),
              ),
              //* table
              SizedBox(height: 24),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ]),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Quantity', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Unit', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Quality', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Calories', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('', color: Colors.black, bold: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  rowItem()
                ],
              ),
 Container(
                alignment: Alignment(0.01, -1.0),
                height: 50.0,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF414042),
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Carbs & Fats',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                          decoration: BoxDecoration(color: kColorPrimary),
                          child: Icon(
                            Icons.add,
                            color: Color(0xFF414042),
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(64),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 100,
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0088FF),
                                    borderRadius: BorderRadius.circular(64),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      kTextHeader('89 / 350', color: Colors.white),
                      SizedBox(width: 6),
                    ],
                  ),
                ),
              ),
              //* table
              SizedBox(height: 24),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ]),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Quantity', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Unit', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Quality', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('Calories', color: Colors.black, bold: true),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, boxShadow: []),
                            child: kTextbody('', color: Colors.black, bold: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  rowItem()
                ],
              ),

              kButtonDefault('Save',
                  marginH: Get.width / 5, paddingV: 0, shadow: true, paddingH: 50),

              SizedBox(height: 12),
              Divider(),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MyOtherCalories()));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xffF1F9E3),
                  ),
                  child: kButtonDefault('My other calories',
                      marginH: Get.width / 6, paddingV: 0, shadow: true, paddingH: 12),
                ),
              ),
              Divider(),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Workout Details",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.upload_sharp,
                      color: Colors.white,
                    )
                  ],
                ),
                height: 45,
                margin: EdgeInsets.symmetric(
                  horizontal: 72,
                ),
                decoration:
                    BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(50)),
              ),
              SizedBox(height: Get.width / 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "Workout",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Gym",
                          style: TextStyle(fontSize: 17),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black)),
                ),
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

                          kTextbody('Workout Description', size: 18, bold: true),
                          EditText(
                            radius: 12,
                            lines: 5,
                            value: '',
                            hint: '',
                            updateFunc: (text) {},
                            validateFunc: (text) {},
                          ),
                          SizedBox(height: 8),

                          Center(
                            child: kButtonDefault('Save',
                                marginH: Get.width / 5, paddingV: 0, shadow: true, paddingH: 50),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('2', color: Colors.black, bold: true),
            ),
          ),
          Container(
            height: 30,
            width: 1.4,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('Gm', color: Colors.black, bold: true),
            ),
          ),
          Container(
            height: 30,
            width: 1.4,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('Chicken Liver', color: Colors.black, bold: true),
            ),
          ),
          Container(
            height: 30,
            width: 1.4,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Flexible(
            flex: 4,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: kTextbody('253', color: Colors.black, bold: true),
            ),
          ),
          Container(
            height: 30,
            width: 1.4,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffE6E6E6)),
              child: Center(
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
