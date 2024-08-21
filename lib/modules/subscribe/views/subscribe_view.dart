import 'dart:io';

import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../controllers/subscribe_controller.dart';
import 'non_user_subscribe_view.dart';

class SubscribeView extends GetView<SubscribeController> {
  List<String> result = [];

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
                return SizedBox(
                  height: Get.height,
                  child: Column(
                    children: [
                      //App bar
                      HomeAppbar(),
                      SizedBox(height: 12),
                      Container(
                        height: Get.height * 0.2,
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
                                    height: Get.height * 0.12,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              color: controller
                                                          .serviceIndex.value ==
                                                      index
                                                  ? kColorPrimary
                                                  : Colors.transparent,
                                              width: controller
                                                          .serviceIndex.value ==
                                                      index
                                                  ? 1
                                                  : 1,
                                            ),
                                            boxShadow: [
                                              if (controller
                                                      .serviceIndex.value ==
                                                  index)
                                                BoxShadow(
                                                  color: kColorPrimary,
                                                  blurRadius: 1,
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 0),
                                                ),
                                              if (controller
                                                      .serviceIndex.value !=
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.2,
                                          child: kTextHeader(
                                              controller.servicesResponse
                                                  .data![index].name!,
                                              bold: true,
                                              size: 12,
                                              color: controller
                                                          .serviceIndex.value ==
                                                      index
                                                  ? kColorPrimary
                                                  : Colors.black87),
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
                                  final payment = controller
                                      .servicesResponse
                                      .data?[controller.serviceIndex.value]
                                      .packages;
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
                                      return GetBuilder<SubscribeController>(
                                        builder: (_) => Container(
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(32),
                                                      topRight:
                                                          Radius.circular(32),
                                                    ),
                                                    color: Colors.grey[900]),
                                                child: Row(
                                                  children: [
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            kTextHeader(
                                                                "${controller.servicesResponse.data?[controller.serviceIndex.value].packages?[i].price ?? ""}",
                                                                size: 22,
                                                                bold: true,
                                                                white: true),
                                                            kTextHeader(
                                                                controller
                                                                        .servicesResponse
                                                                        .data?[controller
                                                                            .serviceIndex
                                                                            .value]
                                                                        .packages?[
                                                                            i]
                                                                        .currency ??
                                                                    "",
                                                                color:
                                                                    kColorPrimary,
                                                                bold: true,
                                                                paddingV: 0,
                                                                paddingH: 0),
                                                          ],
                                                        ),
                                                        kTextHeader(
                                                            controller
                                                                    .servicesResponse
                                                                    .data?[controller
                                                                        .serviceIndex
                                                                        .value]
                                                                    .packages?[
                                                                        i]
                                                                    .duration ??
                                                                "",
                                                            white: true,
                                                            paddingV: 12)
                                                      ],
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Html(
                                                  data: controller
                                                          .servicesResponse
                                                          .data?[controller
                                                              .serviceIndex
                                                              .value]
                                                          .packages?[i]
                                                          .description ??
                                                      "",
                                                ),
                                              ),
                                              if (payment?[i].visaPayments !=
                                                      null &&
                                                  payment?[i].visaPayments ==
                                                      true)
                                                controller.isPaymentVisaClicked
                                                            .value ==
                                                        false
                                                    ? kButton("Payment",
                                                        color: kColorPrimary,
                                                        func: controller
                                                                  .servicesResponse
                                                                  .data?[controller
                                                                      .serviceIndex
                                                                      .value]
                                                                  .packages?[i]
                                                                  .paymentStatus ==
                                                              true
                                                          ?
                                                            () async {
                                                        if (await controller
                                                                .getFromCash() ==
                                                            "haveAllData") {
                                                          controller
                                                              .packagePayment(
                                                                  context:
                                                                      context,
                                                                  packageId: controller
                                                                      .servicesResponse
                                                                      .data![controller
                                                                          .serviceIndex
                                                                          .value]
                                                                      .packages![
                                                                          i]
                                                                      .id!,
                                                                  payMethod:
                                                                      "visa")
                                                              .then((value) {
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    WebViewScreen(
                                                                  url: controller
                                                                      .packagePaymentResponse
                                                                      .data!
                                                                      .paymentUrl!,
                                                                  packageId:
                                                                      controller
                                                                          .packagePaymentResponse
                                                                          .data!
                                                                          .id!,
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                        } else if (await controller
                                                                .getFromCash() ==
                                                            "noLastName") {
                                                          NavigationService.push(context, Routes.editProfileScreen);

                                                        } else {
                                                          _navigateAndDisplaySelection(
                                                              context: context,
                                                              i: i);
                                                        }
                                                      }
                                                         : () {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "  Payment is deactivated  ");
                                                            }
                                                        )
                                                    : Container(
                                                        height: 40,
                                                        child: Lottie.asset(
                                                            'assets/loader.json'),
                                                      ),
                                              if (Platform.isIOS &&
                                                  payment?[i]
                                                          .applePayPayments !=
                                                      null &&
                                                  payment?[i]
                                                          .applePayPayments ==
                                                      true)
                                                controller.isPaymentAppleClicked
                                                            .value ==
                                                        false
                                                    ? kButton("Check out with",
                                                        color:Colors.black,
                                                        func: controller
                                                            .servicesResponse
                                                            .data?[controller
                                                            .serviceIndex
                                                            .value]
                                                            .packages?[i]
                                                            .paymentStatus ==
                                                            true

                                                            ? () async {
                                                        if (await controller
                                                                .getFromCash() ==
                                                            "haveAllData") {
                                                          controller
                                                              .packagePayment(
                                                                  context:
                                                                      context,
                                                                  packageId: controller
                                                                      .servicesResponse
                                                                      .data![controller
                                                                          .serviceIndex
                                                                          .value]
                                                                      .packages![
                                                                          i]
                                                                      .id!,
                                                                  payMethod:
                                                                      "apple_pay")
                                                              .then((value) {
                                                            ///TODO HandleApplePay






                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    " HandleApplePay ");
                                                          });
                                                        } else if (await controller
                                                                .getFromCash() ==
                                                            "noLastName") {
                                                          NavigationService.push(context, Routes.editProfileScreen);

                                                        } else {
                                                          _navigateAndDisplaySelection(
                                                              context: context,
                                                              i: i);
                                                        }
                                                      }:() {
                                                          Fluttertoast
                                                              .showToast(
                                                              msg:
                                                              "  Payment is deactivated  ");
                                                        },
                                                        child: Row(
                                                          children: [
                                                            const Spacer(),
                                                            Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16),
                                                                child: Text(
                                                                  "Check out with",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize: 16,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 4,),
                                                            SvgPicture.asset(
                                                              "assets/img/apple-pay.svg",
                                                              width: 40,
                                                              color:
                                                                  Colors.white,
                                                              height: 40,
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ))
                                                    : Container(
                                                        height: 40,
                                                        child: Lottie.asset(
                                                            'assets/loader.json'),
                                                      )
                                            ],
                                          ),
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
                                    AppImages.kEmptyPackage,
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
                  ),
                );
              },
            )),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection({
    required BuildContext context,
    required int i,
  }) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => NonUserSubscribeView()),
    );

    controller
        .packagePayment(
            context: context,
            name: result[0],
            lastName: result[1],
            email: result[2],
            phone: result[3],
            packageId: controller.servicesResponse
                .data![controller.serviceIndex.value].packages![i].id!,
            payMethod: '')
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: controller.packagePaymentResponse.data!.paymentUrl!,
            packageId: controller.packagePaymentResponse.data!.id!,
          ),
        ),
      );
    });
  }
}
