import 'dart:developer';

import 'package:app/app/modules/cart/views/web_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/subscribe/controllers/subscribe_controller.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SubscribeView extends GetView<SubscribeController> {
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
                if (controller.isLoading.value)
                  return Center(child: CircularLoadingWidget());
                if (controller.error.value.isNotEmpty)
                  return errorHandler(controller.error.value, controller);
                return Column(
                  children: [
                    //App bar
                    HomeAppbar(),
                    SizedBox(height: 12),
                    Container(
                      height: 120,
                      child: ListView.builder(
                          itemCount: controller.servicesResponse.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Obx(
                              () => InkWell(
                                onTap: () {
                                  controller.selectedIndex(index);
                                },
                                child: Container(
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 28, vertical: 12),
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                            color:
                                                controller.serviceIndex.value ==
                                                        index
                                                    ? kColorPrimary
                                                    : Colors.transparent,
                                            width:
                                                controller.serviceIndex.value ==
                                                        index
                                                    ? 1
                                                    : 1,
                                          ),
                                          boxShadow: [
                                            if (controller.serviceIndex.value ==
                                                index)
                                              BoxShadow(
                                                color: kColorPrimary,
                                                blurRadius: 1,
                                                spreadRadius: 1,
                                                offset: Offset(0, 0),
                                              ),
                                            if (controller.serviceIndex.value !=
                                                index)
                                              BoxShadow(
                                                color: const Color(0xFF414042)
                                                    .withOpacity(0.35),
                                                offset: Offset(1, 1.0),
                                                blurRadius: 3.0,
                                              ),
                                          ],
                                        ),
                                        child: Image.network(
                                          "${controller.servicesResponse.data![index].image}",
                                          width: 50,
                                          height: 40,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.2,
                                        child: Text(
                                          controller.servicesResponse
                                              .data![index].name!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                controller.serviceIndex.value ==
                                                        index
                                                    ? kColorPrimary
                                                    : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    controller
                                .servicesResponse
                                .data?[controller.serviceIndex.value]
                                .packages
                                ?.length !=
                            0
                        ? Expanded(
                            child: AnimatedBuilder(
                              animation: controller.pc,
                              builder: (context, child) {
                                return PageView.builder(
                                  controller: controller.pc,
                                  onPageChanged: (value) {
                                    controller.currentPageIndex.value =
                                        controller.pc.page!.round();
                                  },
                                  itemCount: controller
                                      .servicesResponse
                                      .data?[controller.serviceIndex.value]
                                      .packages
                                      ?.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[200]!,
                                              offset: Offset(3, 3),
                                              spreadRadius: 6,
                                              blurRadius: 6,
                                            )
                                          ]),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: Get.height / 14),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(32),
                                                  topRight: Radius.circular(32),
                                                ),
                                                color: Colors.grey[900]),
                                            child:    GetBuilder<SubscribeController>(
                                              builder: (_) =>  Row(
                                                children: [
                                                  Spacer(),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 8),
                                                        kTextHeader(
                                                            "${controller.servicesResponse.data?[controller.serviceIndex.value].packages?[i].price??""} ${
                                                                controller.isLE ==
                                                                    true
                                                                    ? "USD"
                                                                    : "LE"
                                                            }"
                                                                ,
                                                            size: 22,
                                                            bold: true,
                                                            white: true),
                                                        kTextHeader(
                                                            controller
                                                                    .servicesResponse
                                                                    .data?[controller
                                                                        .serviceIndex
                                                                        .value]
                                                                    .packages?[i]
                                                                    .duration ??
                                                                "",
                                                            white: true,
                                                            paddingV: 12)
                                                      ],
                                                    ),
                                                  ),
                                              Expanded(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () => controller
                                                                  .exchangePrice(),
                                                              child: Column(
                                                                children: [
                                                                  kTextHeader(
                                                                      controller.isLE ==
                                                                              false
                                                                          ? "USD"
                                                                          : "LE",
                                                                      color:
                                                                          kColorPrimary,
                                                                      bold: true),
                                                                  SvgPicture.asset(
                                                                      'assets/icons/exchange.svg'),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Html(
                                              data: controller
                                                  .servicesResponse
                                                  .data?[controller
                                                      .serviceIndex.value]
                                                  .packages?[i]
                                                  .description,
                                            ),
                                          ),
                                          kButton("Payment", func: () {
                                            Fluttertoast.showToast(msg: "Loading ..");
                                            controller
                                                .packagePayment(
                                                    packageId: controller
                                                        .servicesResponse
                                                        .data![controller
                                                            .serviceIndex.value]
                                                        .packages![i]
                                                        .id!)
                                                .then((value) {
                                              log(controller
                                                  .packagePaymentResponse
                                                  .message!);
                                              log(controller
                                                  .packagePaymentResponse
                                                  .success!
                                                  .toString());
                                              log(controller
                                                  .packagePaymentResponse
                                                  .data!
                                                  .paymentUrl!);
                                              log(controller
                                                  .packagePaymentResponse
                                                  .data!
                                                  .price!);
                                              log(controller
                                                  .packagePaymentResponse
                                                  .data!
                                                  .date!);
                                              log(controller
                                                  .packagePaymentResponse
                                                  .data!
                                                  .name!);
                                                      Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      WebViewScreen(
                                                        url: controller
                                                            .packagePaymentResponse
                                                            .data!
                                                            .paymentUrl!,
                                                      ),
                                                ),
                                              );
                                            });
                                            /*  Get.toNamed(
                                        Routes.PAYMENT,
                                      );*/
                                          }),
                                          SizedBox(height: 18),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.2),
                            child: Column(
                              children: [
                                Image.asset(
                                  kEmptyPackage,
                                  scale: 5,
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                kTextbody("Packages are empty!", size: 16),
                              ],
                            ),
                          ),
                    SizedBox(height: 20),
                  ],
                );
              },
            )),
      ),
    );
  }
}
