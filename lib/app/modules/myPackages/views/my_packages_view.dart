import 'package:app/app/modules/cart/views/web_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/invoice/views/invoice_view.dart';
import 'package:app/app/modules/myPackages/controllers/my_packages_controller.dart';
import 'package:app/app/modules/profile/edit_profile_view.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MyPackagesView extends GetView<MyPackagesController> {
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
                    //App bar
                    HomeAppbar(),
                    SizedBox(height: 12),
                    PageLable(name: " My Packages"),
                    SizedBox(height: 12),
                    controller.myPackagesResponse.data!.orders!.isEmpty
                        ? Expanded(
                            child: Padding(
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
                                  kTextbody("  Empty!  ", size: 16),
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: SizedBox(
                              height: Get.height,
                              child: ListView.separated(
                                  itemBuilder: (context, index) => Column(
                                        children: [
                                          Container(
                                            color: Color(0xffF1F1F1),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 18),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: kTextHeader(
                                                          controller
                                                                  .myPackagesResponse
                                                                  .data
                                                                  ?.orders?[
                                                                      index]
                                                                  .name ??
                                                              "",
                                                          color: kColorPrimary,
                                                          align:
                                                              TextAlign.start,
                                                          maxLines: 2,
                                                          bold: true,
                                                          paddingH: 12,
                                                          size: 20),
                                                    ),
                                                    kTextHeader(
                                                        "${controller.myPackagesResponse.data?.orders?[index].price.toString() ?? ""} LE",
                                                        color: Colors.black,
                                                        align: TextAlign.end,
                                                        bold: true,
                                                        paddingH: 12,
                                                        size: 20),
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: kTextHeader(
                                                          controller
                                                                  .myPackagesResponse
                                                                  .data
                                                                  ?.orders?[
                                                                      index]
                                                                  .date ??
                                                              "",
                                                          align:
                                                              TextAlign.start,
                                                          paddingH: 12),
                                                    ),
                                                    Spacer(),
                                                    kTextHeader(
                                                        controller
                                                                .myPackagesResponse
                                                                .data
                                                                ?.orders?[index]
                                                                .package ??
                                                            "",
                                                        align: TextAlign.end,
                                                        color: Colors.black,
                                                        paddingH: 12),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            controller
                                                                    .myPackagesResponse
                                                                    .data!
                                                                    .orders![
                                                                        index]
                                                                    .paymentStatus!
                                                                    .contains(
                                                                        'confirmed')
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    size: 16,
                                                                    color:
                                                                        kColorPrimary)
                                                                : Icon(
                                                                    Icons.error,
                                                                    size: 16,
                                                                    color:
                                                                        kRedColor),
                                                            kTextHeader(
                                                                controller
                                                                            .myPackagesResponse
                                                                            .data
                                                                            ?.orders?[
                                                                                index]
                                                                            .paymentStatus ==
                                                                        ""
                                                                    ? ""
                                                                    : controller
                                                                            .myPackagesResponse
                                                                            .data!
                                                                            .orders![
                                                                                index]
                                                                            .paymentStatus!
                                                                            .contains(
                                                                                "confirmed")
                                                                        ? "Successful"
                                                                        : "Failed",
                                                                bold: true,
                                                                paddingH: 8,
                                                                align: TextAlign
                                                                    .start,
                                                                color: controller
                                                                        .myPackagesResponse
                                                                        .data!
                                                                        .orders![
                                                                            index]
                                                                        .paymentStatus!
                                                                        .contains(
                                                                            'confirmed')
                                                                    ? kColorPrimary
                                                                    : kRedColor),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    controller
                                                        .myPackagesResponse
                                                        .data
                                                        ?.orders?[index].paymentUrl==null?     Expanded(
                                                      child: Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) => InvoiceView(
                                                                      packageId: controller.myPackagesResponse.data?.orders?[index].id,
                                                                    )));
                                                          },
                                                          child: Center(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: kColorPrimary,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      64),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                          0.4),
                                                                      blurRadius:
                                                                      1,
                                                                      spreadRadius:
                                                                      1,
                                                                      offset:
                                                                      Offset(
                                                                          0,
                                                                          1),
                                                                    ),
                                                                  ]),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    8,
                                                                    vertical:
                                                                    4),
                                                                child:
                                                                kTextHeader(
                                                                  "Details ",
                                                                  size: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  bold: true,
                                                                  paddingH: 12,
                                                                  paddingV: 4,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ):
                                                    Expanded(
                                                      child: Center(
                                                        child: GestureDetector(
                                                          onTap: controller
                                                                      .myPackagesResponse
                                                                      .data
                                                                      ?.orders?[
                                                                          index]
                                                                      .paymentUrlStatus ==
                                                                  true
                                                              ? () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) => WebViewScreen(
                                                                      url: controller.myPackagesResponse.data!.orders![index].paymentUrl!,
                                                                      packageId: controller.myPackagesResponse.data!.orders?[index].id!,
                                                                    )));

                                                                }
                                                              : () {
                                                                           Fluttertoast.showToast(msg: "  Payment is deactivated  ");

                                                          },
                                                          child: Center(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                  controller
                                                                      .myPackagesResponse
                                                                      .data
                                                                      ?.orders?[
                                                                  index].paymentUrlStatus == true ? kColorPrimary:  kColorAccent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              64),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.4),
                                                                      blurRadius:
                                                                          1,
                                                                      spreadRadius:
                                                                          1,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              1),
                                                                    ),
                                                                  ]),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    kTextHeader(
                                                                "Pay ",
                                                                  size: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  bold: true,
                                                                  paddingH: 12,
                                                                  paddingV: 4,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 12),
                                  itemCount: controller
                                      .myPackagesResponse.data!.orders!.length),
                            ),
                          ),
                    controller.myPackagesResponse.data!.subscriptionStatus==true ?  GestureDetector(
                      onTap:() async {
                        if (await controller.getFromCash() == "haveAllData") {
                          Get.toNamed(Routes.SUBSCRIBE, arguments: null);
                        } else if (await controller.getFromCash() ==
                            "noLastName") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditProfileView()));
                        } else {
                          Get.toNamed(Routes.SUBSCRIBE, arguments: null);
                        }
                      },
                      child: Center(
                        child: Container(
                          width: Get.width / 1.4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Color(0xffFFB62B),
                            borderRadius: BorderRadius.circular(64),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img/premium.png',
                                width: 30,
                                height: 30,
                              ),
                              kTextHeader('Subscribe new package',
                                  size: 16,
                                  color: Colors.white,
                                  bold: true,
                                  paddingH: 16,
                                  paddingV: 4),
                            ],
                          ),
                        ),
                      ),
                    ):SizedBox(),
                  ],
                );
              },
            )),
      ),
    );
  }
}
