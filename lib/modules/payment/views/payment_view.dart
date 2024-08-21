import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(
              () {
                if (controller.loading.value)
                  return Center(child: CircularLoadingWidget());

                if (controller.error.value.isNotEmpty)
                  return errorHandler(controller.error.value, controller);

                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          //App bar
                          HomeAppbar(),
                          SizedBox(height: 12),
                          PageLable(name: " Payment"),
                          SizedBox(height: 12),
                          Container(
                            color: Color(0xffF1F1F1),
                            child: Column(
                              children: [
                                SizedBox(height: 18),
                                Row(
                                  children: [
                                    kTextHeader('Physiotherapy',
                                        color: kColorPrimary,
                                        bold: true,
                                        paddingH: 12,
                                        size: 20),
                                    Spacer(),
                                    kTextHeader('150 L.E',
                                        color: Colors.black,
                                        bold: true,
                                        paddingH: 12,
                                        size: 20),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    kTextHeader('03/06/2022', paddingH: 12),
                                    Spacer(),
                                    kTextHeader('1 Month',
                                        color: Colors.black, paddingH: 12),
                                  ],
                                ),
                                SizedBox(height: 18),
                              ],
                            ),
                          ),
                          SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: kColorPrimary, width: 1)),
                            ),
                            child: RadioListTile(
                              value: 'visa',
                              groupValue: 'visa',
                              activeColor: kColorPrimary,
                              onChanged: (value) {},
                              title: Row(
                                children: [
                                  Image.asset('assets/img/visa.png',
                                      width: 40, height: 40),
                                  SizedBox(width: 12),
                                  kTextHeader('Online Payment',
                                      align: TextAlign.start, paddingH: 0),
                                ],
                              ),
                            ),
                          ),
                          /*     SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[200]!, width: 1)),
                            ),
                            child: RadioListTile(
                              value: 'cash',
                              groupValue: 'visa',
                              activeColor: kColorPrimary,
                              onChanged: (value) {},
                              title: Row(
                                children: [
                                  Image.asset('assets/img/cash.png', width: 40, height: 40),
                                  SizedBox(width: 12),
                                  kTextHeader('Cash', align: TextAlign.start, paddingH: 0),
                                ],
                              ),
                            ),
                          ),*/
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    kButton("Confirm"),
                    SizedBox(height: Get.height / 10),
                  ],
                );
              },
            )),
      ),
    );
  }
}
