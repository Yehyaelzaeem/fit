import 'package:app/app/models/my_orders_response.dart';
import 'package:app/app/modules/orders/controllers/orders_controller.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/helper/methods.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:app/un_coplete_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersView extends GetView<OrdersController> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(children: [
              appBar(),
              SizedBox(height: 12),
              PageLable(name: "My Orders"),
              SizedBox(height: 12),
              Obx(() {
                if (controller.loading.value) return Center(child: CircularLoadingWidget());
                if (controller.requiredAuth.value) return IncompleteData();
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF414042),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF414042),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedTap.value = 1;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.selectedTap.value == 1 ? Colors.white : Color(0xFF414042),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                child: kTextbody(
                                  "Completed",
                                  paddingV: 8,
                                  color: controller.selectedTap.value == 1 ? kColorPrimary : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedTap.value = 2;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.selectedTap.value == 2 ? Colors.white : Color(0xFF414042),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                child: kTextbody(
                                  "Pending",
                                  paddingV: 8,
                                  color: controller.selectedTap.value == 2 ? kColorPrimary : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.response.value.data != null)
                      if (controller.selectedTap.value == 1)
                        ...controller.response.value.data!.completed.map((e) {
                          return singleOrderCard(e);
                        }).toList(),
                    if (controller.response.value.data != null)
                      if (controller.selectedTap.value == 2)
                        ...controller.response.value.data!.pending.map((e) {
                          return singleOrderCard(e);
                        }).toList(),
                  ],
                );
              }),
              //* Subhect
              SizedBox(height: Get.width / 14),
            ])),
      ),
    );
  }

  Widget singleOrderCard(Completed e) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: kTextHeader(
                  controller.getMealsName(e.meals),
                  align: TextAlign.start,
                  paddingH: 12,
                  color: Colors.black,
                  bold: true,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  kTextbody("${e.price} L.E", color: kColorPrimary, bold: true),
                  kTextbody("${getDelivertMethod(e.deliveryMethod)}", color: Colors.black, bold: true),
                  kTextbody(
                    "${e.date}",
                    color: Colors.black,
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              kTextbody("Delivery method : ${getDelivertMethod(e.deliveryMethod)}", color: Colors.black, bold: true, align: TextAlign.start),
                              kTextbody(e.userInfo == null ? '' : "${e.userInfo!.address}", color: Colors.black, bold: true),
                              SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: kColorPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: kTextbody("Location", color: Colors.white, paddingV: 8)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...e.meals.map((element) {
                              return ListTile(
                                title: kTextbody(element.name, color: Colors.black, bold: true, align: TextAlign.start),
                                trailing: kTextbody("${element.price} L.E", color: Colors.black, bold: true),
                              );
                            }).toList(),
                            Container(
                              width: double.infinity,
                              child: kTextbody("Instructions", size: 18, align: TextAlign.start, paddingH: 12),
                            ),
                            SizedBox(height: 6),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              child: EditText(
                                value: getInsturctions(e.deliveryMethod),
                                hintColor: Color(0xff8D8D8D),
                                enable: false,
                                background: Color(0xffF1F1F1),
                                updateFunc: (value) {},
                                noBorder: true,
                                radius: 4,
                                lines: 3,
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black, width: 1.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: kTextbody("Details", color: Colors.black, paddingV: 8)),
                ),
              ),
              SizedBox(width: 20),
            ],
          )
        ],
      ),
    );
  }

  String getInsturctions(String deliveryMethod) {
    String instructions = "";
    if (controller.globalController.mealFeatureHomeResponse.value.data == null) return "";
    if (controller.globalController.mealFeatureHomeResponse.value.data!.info == null) return "";
    if (deliveryMethod == 'Delivery' || deliveryMethod == 'delivery') {
      instructions = "${controller.globalController.mealFeatureHomeResponse.value.data!.info!.deliveryInstructions}";
    } else {
      instructions = "${controller.globalController.mealFeatureHomeResponse.value.data!.info!.pickupInstructions}";
    }
    return instructions;
  }
}
