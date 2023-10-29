import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:app/app/widgets/text_inside_rec.dart';
import 'package:flutter/material.dart';
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
            if (controller.loading.value)
              return Center(child: CircularLoadingWidget());
            if (controller.isLoading.value)
              return Center(child: CircularLoadingWidget());
            return SingleChildScrollView(
              child: Column(
                children: [
                  //App bar
                  appBar(),
                  SizedBox(height: 20),
                  header(),
                  SizedBox(height: 4),
                  ...controller.meals.reversed.map((e) {
                    return singleItem(
                        id: e.id!,
                        title: "${e.name}",
                        price: "${controller.mealPrice(meal: e)} L.E",
                        qty: 'x${e.qty}');
                  }).toList(),
                  SizedBox(height: 12),
                  header2(
                      "Total Price",
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          child: kTextbody("${controller.totalAmount()} L.E",
                              color: Colors.white))),

                  SizedBox(height: 12),
                  // Container(
                  //   width: double.infinity,
                  //   child: kTextbody("Instructions", size: 18, align: TextAlign.start, paddingH: 12),
                  // ),
                  // SizedBox(height: 6),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 12),
                  //   child: EditText(
                  //     value: "Lorem ipsum dolor sit amet, consectetur  elit, sed do eiusmod tempor incididunt ut labore adipiscing",
                  //     hintColor: Color(0xff8D8D8D),
                  //     enable: false,
                  //     background: Color(0xffF1F1F1),
                  //     updateFunc: (value) {},
                  //     noBorder: true,
                  //     radius: 4,
                  //     lines: 3,
                  //   ),
                  // ),

                  SizedBox(height: 8),

                  controller.mealFeatureStatusResponse.data?.isActive == true
                      ? Row(
                          children: [
                            if (controller.mealFeatureStatusResponse.data
                                    ?.deliveryActive ??
                                true)
                              Expanded(
                                  child: kButtonDefault("Delivery", func: () {
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
                                              child: kTextHeader("Delivery",
                                                  color: Colors.white,
                                                  size: 30),
                                            ),
                                          ),
                                          SizedBox(height: 12),

                                          TextInsideRec(
                                            text: controller
                                                .globalController
                                                .mealFeatureHomeResponse
                                                .value
                                                .data!
                                                .info!
                                                .deliveryInstructions!,
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            width: double.infinity,
                                            child: kButtonDefault("Visa",
                                                color: kColorPrimary,
                                                textColor: Colors.white,
                                                border: Border.all(
                                                  color: Color(0xffF1F1F1),
                                                  width: 1,
                                                ), func: () {
                                              Get.back();
                                              controller.createOrder(
                                                  payMethod: 'visa',
                                                  shippingMethod: 'delivery',
                                                  context: context);
                                            }),
                                          ),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                              })),
                            if (controller.mealFeatureStatusResponse.data
                                    ?.pickupActive ??
                                true)
                              Expanded(
                                  child: kButtonDefault("Pick up ", func: () {
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
                                              child: kTextHeader("Pick up",
                                                  color: Colors.white,
                                                  size: 30),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          TextInsideRec(
                                            text:  controller
                                                .globalController
                                                .mealFeatureHomeResponse
                                                .value
                                                .data!
                                                .info!
                                                .pickupInstructions!,
                                          ),
                                          if (controller.globalController.mealFeatureHomeResponse.value.data != null &&
                                              controller.globalController.mealFeatureHomeResponse.value.data!.info != null &&
                                              controller.globalController.mealFeatureHomeResponse.value.data!.info!.location != null &&
                                              controller.globalController.mealFeatureHomeResponse.value.data!.info!.location!.isNotEmpty)
                                            Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(9.0), color: const Color(0xFFF1F1F1),),
                                            child: Column(
                                              children: <Widget>[
                                               /* TextInsideRec(
                                                  text:  controller
                                                      .globalController
                                                      .mealFeatureHomeResponse
                                                      .value
                                                      .data!
                                                      .info!
                                                      .pickupInstructions!,
                                                ),*/
                                                  GestureDetector(
                                                    onTap: () {launch(controller.globalController.mealFeatureHomeResponse.value.data!.info!.location!);},
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 39.0,
                                                      decoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    9.0),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        border: Border.all(
                                                          width: 1.0,
                                                          color: const Color(
                                                              0xFF7FC902),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .location_on,
                                                              color:
                                                                  kColorPrimary),
                                                          SizedBox(width: 4),
                                                          kTextbody(
                                                              'Location',
                                                              size: 18,
                                                              color:
                                                                  kColorPrimary),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          kButtonDefault("Visa",
                                              color: kColorPrimary,
                                              textColor: Colors.white,
                                              border: Border.all(
                                                color: Color(0xffF1F1F1),
                                                width: 1,
                                              ), func: () {
                                            Get.back();
                                            controller.createOrder(
                                                shippingMethod: "pick_up",
                                                payMethod: "visa",
                                                context: context);
                                          }),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                              })),
                          ],
                        )
                      : SizedBox()
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
            child: Center(
                child: kTextbody(title,
                    color: Colors.white, bold: true, size: 16)),
          ),
          action,
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: MediaQuery.of(Get.context!).size.width,
      height: 65,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
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
              height: 44,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Widget singleItem({
    required int id,
    required String title,
    required String price,
    required String qty,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffF1F1F1),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 12),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              height: 20,
              child: kTextbody(qty, color: kColorPrimary, size: 12)),
          SizedBox(width: 4),
          Expanded(
              child: kTextbody("$title",
                  color: kColorPrimary, align: TextAlign.start, bold: true)),
          SizedBox(width: 4),
          kTextbody(price, color: Colors.black, paddingV: 12),
          SizedBox(width: 4),
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
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
