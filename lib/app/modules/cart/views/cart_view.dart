import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Obx(() {
            if (controller.loading.value) return Center(child: CircularLoadingWidget());

            return SingleChildScrollView(
              child: Column(
                children: [
                  //App bar
                  appBar(),
                  SizedBox(height: 20),
                  header(),
                  SizedBox(height: 4),
                  ...controller.meals.map((e) {
                    return singleItem(id: e.id!, title: "${e.name}", price: "${e.price} L.E");
                  }).toList(),
                  SizedBox(height: 12),
                  header2("Total Price", Container(margin: EdgeInsets.symmetric(horizontal: 12), child: kTextbody("${controller.totalAmount()} L.E", color: Colors.white))),

                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    child: kTextbody("Instructions", size: 18, align: TextAlign.start, paddingH: 12),
                  ),
                  SizedBox(height: 6),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: EditText(
                      value: "Lorem ipsum dolor sit amet, consectetur  elit, sed do eiusmod tempor incididunt ut labore adipiscing",
                      hintColor: Color(0xff8D8D8D),
                      enable: false,
                      background: Color(0xffF1F1F1),
                      updateFunc: (value) {},
                      noBorder: true,
                      radius: 4,
                      lines: 3,
                    ),
                  ),
                  SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                          child: kButtonDefault("Delivery", func: () {
                        Get.toNamed(Routes.CART);
                      })),
                      Expanded(
                          child: kButtonDefault("Pick up ", color: Color(0xffF1F1F1), textColor: Colors.black, border: Border.all(color: Color(0xffF1F1F1), width: 1), func: () {
                        Get.dialog(Dialog(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    color: Color(0xFF414042),
                                    child: Center(
                                      child: kTextHeader("Pick up", color: Colors.white, size: 30),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    alignment: Alignment(0.0, 0.12),
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                    height: 155.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9.0),
                                      color: const Color(0xFFF1F1F1),
                                    ),
                                    child: SizedBox(
                                      width: 307.0,
                                      height: 155.0,
                                      child: Column(
                                        children: <Widget>[
                                          Spacer(flex: 23),
                                          Align(
                                            alignment: Alignment(-0.09, 0.0),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                controller.globalController.mealFeatureHomeResponse.value.data!.info!.about!,
                                                style: GoogleFonts.cairo(
                                                  fontSize: 13.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.38,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () {
                                              launch(controller.globalController.mealFeatureHomeResponse.value.data!.info!.location!);
                                            },
                                            child: Container(
                                              alignment: Alignment(-0.04, -0.33),
                                              width: double.infinity,
                                              margin: EdgeInsets.symmetric(horizontal: 12),
                                              height: 39.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(9.0),
                                                color: const Color(0xFFF1F1F1),
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: const Color(0xFF7FC902),
                                                ),
                                              ),
                                              child: SizedBox(
                                                width: 307.0,
                                                height: 36.0,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(flex: 103),
                                                    Align(
                                                      alignment: Alignment(0.0, 0.1),
                                                      child: SvgPicture.string(
                                                        // Icon material-location-on
                                                        '<svg viewBox="130.4 401.0 11.2 16.0" ><path transform="translate(122.9, 398.0)" d="M 13.10000038146973 3 C 10.00399971008301 3 7.5 5.504000186920166 7.5 8.600000381469727 C 7.5 12.80000019073486 13.10000038146973 19 13.10000038146973 19 C 13.10000038146973 19 18.70000076293945 12.80000019073486 18.70000076293945 8.600000381469727 C 18.70000076293945 5.504000186920166 16.19600105285645 3 13.10000038146973 3 Z M 13.10000038146973 10.60000038146973 C 11.99600028991699 10.60000038146973 11.10000038146973 9.703999519348145 11.10000038146973 8.600000381469727 C 11.10000038146973 7.49600076675415 11.99600028991699 6.600000381469727 13.10000038146973 6.600000381469727 C 14.20400047302246 6.600000381469727 15.10000038146973 7.49600076675415 15.10000038146973 8.600000381469727 C 15.10000038146973 9.703999519348145 14.20400047302246 10.60000038146973 13.10000038146973 10.60000038146973 Z" fill="#7fc902" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                                        width: 11.2,
                                                        height: 16.0,
                                                      ),
                                                    ),
                                                    Spacer(flex: 10),
                                                    Text(
                                                      'Location',
                                                      style: GoogleFonts.cairo(
                                                        fontSize: 19.0,
                                                        color: const Color(0xFF7FC902),
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Spacer(flex: 112),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(flex: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  kButtonDefault("Submit",
                                      color: Color(0xffF1F1F1),
                                      textColor: Colors.black,
                                      border: Border.all(
                                        color: Color(0xffF1F1F1),
                                        width: 1,
                                      ), func: () {
                                    Get.back();
                                    controller.createOrder("pick_up");
                                  }),
                                  SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ),
                        ));
                      })),
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      children: [
        PageLable(name: "Cart"),
        Expanded(child: SizedBox(width: 10)),
      ],
    );
  }

  Widget header2(String title, Widget action) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xFF414042),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Center(child: kTextbody(title, color: Colors.white, bold: true, size: 16)),
          ),
          action,
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              kLogoChellFullRow,
              height: 44,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Icon(
                Icons.arrow_back_ios,
                size: 26,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget singleItem({
    required int id,
    required String title,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffF1F1F1),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: kTextbody("$title $id", color: kColorPrimary, align: TextAlign.start, bold: true)),
          kTextbody(price, color: Colors.black, paddingV: 12),
          GestureDetector(
            onTap: () {
              controller.deleteMeal(id);
            },
            child: Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.delete,
                  size: 18,
                  color: Colors.red,
                )),
          ),
        ],
      ),
    );
  }
}
