import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/diary_controller.dart';

class DiaryView extends GetView<DiaryController> {
  final controller = Get.find(tag: 'DiaryController');
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
                        style: GoogleFonts.cairo(
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
                          Icon(
                            Icons.picture_as_pdf_sharp,
                            color: Colors.white,
                          ),
                          kTextHeader('PDF', color: Colors.white)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      margin: EdgeInsets.symmetric(horizontal: 18),
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
                        controller.list.firstWhere((element) => element.id == item.id).selected = !item.selected;
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
                        style: GoogleFonts.cairo(
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
                      kTextHeader('270 / 350', color: Colors.white),
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
                          flex: 2,
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
                          flex: 1,
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
                          flex: 2,
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
                          flex: 2,
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
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 2,
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
                        flex: 1,
                        child: Container(
                          height: 30,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                          child: kTextbody('Kg', color: Colors.black, bold: true),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 1.4,
                        decoration: BoxDecoration(color: Colors.grey[700]),
                      ),
                      Flexible(
                        flex: 2,
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
                        flex: 2,
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
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 1.4,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 2,
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
                        flex: 1,
                        child: Container(
                          height: 30,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Color(0xffE6E6E6)),
                          child: kTextbody('Kg', color: Colors.black, bold: true),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 1.4,
                        decoration: BoxDecoration(color: Colors.grey[700]),
                      ),
                      Flexible(
                        flex: 2,
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
                        flex: 2,
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
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 24),

              kButtonDefault('Save', marginH: Get.width / 5, paddingV: 0, shadow: true, paddingH: 50),

              SizedBox(height: 12),
              Divider(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Color(0xffF1F9E3),
                ),
                child: kButtonDefault('My other calories', marginH: Get.width / 6, paddingV: 0, shadow: true, paddingH: 12),
              ),
              Divider(),
              SizedBox(height: 12),

              SizedBox(height: Get.width / 14),
            ],
          ),
        ),
      ),
    );
  }
}
