import 'dart:io';

import 'package:app/app/modules/cart/views/web_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/invoice/views/invoice_view.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../models/my_packages_response.dart';
import '../../../network_util/api_provider.dart';
import '../../../network_util/shared_helper.dart';
import '../../main_un_auth.dart';
import '../../subscribe/views/non_user_subscribe_view.dart';

class MyPackagesView extends StatefulWidget {
  @override
  State<MyPackagesView> createState() => _MyPackagesViewState();
}

class _MyPackagesViewState extends State<MyPackagesView> {
  final error = ''.obs;
  final loading = true.obs;
  final userPhone = ''.obs;
  final userEmail = ''.obs;
  final userName = ''.obs;
  final userLastName = ''.obs;
  final invoice = ''.obs;
  bool isGuest = false;
  bool isGuestSaved = false;
  String userId = "";

  MyPackagesResponse myPackagesResponse = MyPackagesResponse();

  void getMyPackagesList() async {
    userId = await SharedHelper().readString(CachingKey.USER_ID);
    isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
    isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    if (userId.isNotEmpty) {
      await ApiProvider().myPackagesResponse().then((value) {
        if (value.success == true) {
          myPackagesResponse = value;
          loading.value = false;
        } else {
          Fluttertoast.showToast(msg: "Server Error");
        }
      });
    } else if (isGuest) {
      await ApiProvider().myPackagesResponse().then((value) {
        if (value.success == true) {
          myPackagesResponse = value;
          loading.value = false;
        } else {
          Fluttertoast.showToast(msg: "Server Error");
        }
      });
    } else if (isGuestSaved == true) {
      await ApiProvider().myPackagesResponse().then((value) {
        if (value.success == true) {
          myPackagesResponse = value;
          loading.value = false;
        } else {
          Fluttertoast.showToast(msg: "Server Error");
        }
      });
    } else {
      loading.value = false;
    }
  }

  Future<String> getFromCash() async {
    invoice.value = await SharedHelper().readString(CachingKey.INVOICE);
    userPhone.value = await SharedHelper().readString(CachingKey.PHONE);
    userEmail.value = await SharedHelper().readString(CachingKey.EMAIL);
    userName.value = await SharedHelper().readString(CachingKey.USER_NAME);
    userLastName.value =
        await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    if (userPhone.value.isEmpty &&
        userEmail.value.isEmpty &&
        userName.value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noPhone";
    } else if (userLastName.value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noLastName";
    } else {
      print("Shared = true");
      return await "haveAllData";
    }
  }

  @override
  void initState() {
    getMyPackagesList();
    if (Get.arguments != null) myPackagesResponse = Get.arguments;
    getFromCash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _willPopCallback() async {
      /*     if (await SharedHelper().readString(CachingKey.INVOICE) == 'INVOICE') {
        await Get.toNamed(
          Routes.HOME,
        );
      }*/
      await Get.toNamed(
        Routes.HOME,
      );
      return true;
    }

    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: _willPopCallback,
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Obx(
                () {
                  if (loading.value)
                    return Center(child: CircularLoadingWidget());
                  if (error.value.isNotEmpty)
                    return Expanded(
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
                    );
                  return userId.isNotEmpty
                      ? Column(
                          children: [
                            //App bar
                            HomeAppbar(
                              onBack: () async {
                                await Get.toNamed(
                                  Routes.HOME,
                                );
                              },
                            ),
                            SizedBox(height: 12),
                            PageLable(name: " My Packages"),
                            SizedBox(height: 12),
                            myPackagesResponse.data!.orders!.isEmpty
                                ? Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: Get.height * 0.2),
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
                                          itemBuilder:
                                              (context, index) => Column(
                                                    children: [
                                                      Container(
                                                        color:
                                                            Color(0xffF1F1F1),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                                height: 18),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: kTextHeader(
                                                                      myPackagesResponse
                                                                              .data
                                                                              ?.orders?[
                                                                                  index]
                                                                              .name ??
                                                                          "",
                                                                      color:
                                                                          kColorPrimary,
                                                                      align: TextAlign
                                                                          .start,
                                                                      maxLines:
                                                                          2,
                                                                      bold:
                                                                          true,
                                                                      paddingH:
                                                                          12,
                                                                      size: 20),
                                                                ),
                                                                kTextHeader(
                                                                    "${myPackagesResponse.data?.orders?[index].price.toString() ?? ""} LE",
                                                                    color: Colors
                                                                        .black,
                                                                    align:
                                                                        TextAlign
                                                                            .end,
                                                                    bold: true,
                                                                    paddingH:
                                                                        12,
                                                                    size: 20),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 12),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: kTextHeader(
                                                                      myPackagesResponse
                                                                              .data
                                                                              ?.orders?[
                                                                                  index]
                                                                              .date ??
                                                                          "",
                                                                      align: TextAlign
                                                                          .start,
                                                                      paddingH:
                                                                          12),
                                                                ),
                                                                Spacer(),
                                                                kTextHeader(
                                                                    myPackagesResponse
                                                                            .data
                                                                            ?.orders?[
                                                                                index]
                                                                            .package ??
                                                                        "",
                                                                    align:
                                                                        TextAlign
                                                                            .end,
                                                                    color: Colors
                                                                        .black,
                                                                    paddingH:
                                                                        12),
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
                                                                        myPackagesResponse.data!.orders![index].paymentStatus!.contains('confirmed')
                                                                            ? Icon(Icons.check_circle,
                                                                                size: 16,
                                                                                color: kColorPrimary)
                                                                            : Icon(Icons.error, size: 16, color: kRedColor),
                                                                        kTextHeader(
                                                                            myPackagesResponse.data?.orders?[index].paymentStatus == ""
                                                                                ? ""
                                                                                : myPackagesResponse.data!.orders![index].paymentStatus!.contains("confirmed")
                                                                                    ? "Successful"
                                                                                    : "Failed",
                                                                            bold: true,
                                                                            paddingH: 8,
                                                                            align: TextAlign.start,
                                                                            color: myPackagesResponse.data!.orders![index].paymentStatus!.contains('confirmed') ? kColorPrimary : kRedColor),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                myPackagesResponse
                                                                            .data
                                                                            ?.orders?[
                                                                                index]
                                                                            .paymentUrl ==
                                                                        null
                                                                    ? Expanded(
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pushReplacement(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (_) => InvoiceView(
                                                                                            packageId: myPackagesResponse.data?.orders?[index].id,
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Center(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(64), boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey.withOpacity(0.4),
                                                                                    blurRadius: 1,
                                                                                    spreadRadius: 1,
                                                                                    offset: Offset(0, 1),
                                                                                  ),
                                                                                ]),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                                  child: kTextHeader(
                                                                                    "Details ",
                                                                                    size: 16,
                                                                                    color: Colors.white,
                                                                                    bold: true,
                                                                                    paddingH: 12,
                                                                                    paddingV: 4,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : myPackagesResponse.data?.visaStatue ==
                                                                            true
                                                                        ? Expanded(
                                                                            child:
                                                                                Center(
                                                                              child: GestureDetector(
                                                                                onTap: myPackagesResponse.data?.orders?[index].paymentUrlStatus == true
                                                                                    ? () {
                                                                                        Navigator.pushReplacement(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (_) => WebViewScreen(
                                                                                                      url: myPackagesResponse.data!.orders![index].paymentUrl!,
                                                                                                      packageId: myPackagesResponse.data!.orders?[index].id!,
                                                                                                    )));
                                                                                      }
                                                                                    : () {
                                                                                        Fluttertoast.showToast(msg: "  Payment is deactivated  ");
                                                                                      },
                                                                                child: Center(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: myPackagesResponse.data?.orders?[index].paymentUrlStatus == true ? kColorPrimary : kColorAccent, borderRadius: BorderRadius.circular(64), boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey.withOpacity(0.4),
                                                                                        blurRadius: 1,
                                                                                        spreadRadius: 1,
                                                                                        offset: Offset(0, 1),
                                                                                      ),
                                                                                    ]),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                                      child: kTextHeader(
                                                                                        "Pay ",
                                                                                        size: 16,
                                                                                        color: Colors.white,
                                                                                        bold: true,
                                                                                        paddingH: 12,
                                                                                        paddingV: 4,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : (myPackagesResponse.data?.applePayStatus == true && Platform.isIOS)
                                                                            ? Expanded(
                                                                                child: Center(
                                                                                  child: GestureDetector(
                                                                                    onTap: myPackagesResponse.data?.orders?[index].paymentUrlStatus == true
                                                                                        ? () {
                                                                                            ///TODO HandleApplePay






                                                                                            Fluttertoast.showToast(msg: " HandleApplePay ");
                                                                                          }
                                                                                        : () {
                                                                                            Fluttertoast.showToast(msg: "  Payment is deactivated  ");
                                                                                          },
                                                                                    child: Center(
                                                                                      child: Container(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                                          child: SvgPicture.asset(
                                                                                            "assets/img/pay.svg",
                                                                                            color: Colors.black,
                                                                                            height: 50,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : SizedBox(),
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
                                          itemCount: myPackagesResponse
                                              .data!.orders!.length),
                                    ),
                                  ),
                            myPackagesResponse.data!.subscriptionStatus == true
                                ? GestureDetector(
                                    onTap: () async {
                                      if (await getFromCash() ==
                                          "haveAllData") {
                                        Get.offNamed(Routes.SUBSCRIBE,
                                            arguments: null);
                                      } else if (await getFromCash() ==
                                          "noLastName") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    EditProfileView()));
                                      } else {
                                        Get.offNamed(Routes.SUBSCRIBE,
                                            arguments: null);
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        width: Get.width / 1.4,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFB62B),
                                          borderRadius:
                                              BorderRadius.circular(64),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                  )
                                : SizedBox(),
                          ],
                        )
                      : isGuestSaved
                          ? Column(
                              children: [
                                //App bar
                                HomeAppbar(
                                  onBack: () async {
                                    await Get.toNamed(
                                      Routes.HOME,
                                    );
                                  },
                                ),
                                SizedBox(height: 12),
                                PageLable(name: " My Packages"),
                                SizedBox(height: 12),
                                myPackagesResponse.data!.orders!.isEmpty
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: Get.height * 0.2),
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
                                              itemBuilder:
                                                  (context, index) => Column(
                                                        children: [
                                                          Container(
                                                            color: Color(
                                                                0xffF1F1F1),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                    height: 18),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: kTextHeader(
                                                                          myPackagesResponse.data?.orders?[index].name ??
                                                                              "",
                                                                          color:
                                                                              kColorPrimary,
                                                                          align: TextAlign
                                                                              .start,
                                                                          maxLines:
                                                                              2,
                                                                          bold:
                                                                              true,
                                                                          paddingH:
                                                                              12,
                                                                          size:
                                                                              20),
                                                                    ),
                                                                    kTextHeader(
                                                                        "${myPackagesResponse.data?.orders?[index].price.toString() ?? ""} LE",
                                                                        color: Colors
                                                                            .black,
                                                                        align: TextAlign
                                                                            .end,
                                                                        bold:
                                                                            true,
                                                                        paddingH:
                                                                            12,
                                                                        size:
                                                                            20),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 12),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: kTextHeader(
                                                                          myPackagesResponse.data?.orders?[index].date ??
                                                                              "",
                                                                          align: TextAlign
                                                                              .start,
                                                                          paddingH:
                                                                              12),
                                                                    ),
                                                                    Spacer(),
                                                                    kTextHeader(
                                                                        myPackagesResponse.data?.orders?[index].package ??
                                                                            "",
                                                                        align: TextAlign
                                                                            .end,
                                                                        color: Colors
                                                                            .black,
                                                                        paddingH:
                                                                            12),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 8),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            myPackagesResponse.data!.orders![index].paymentStatus!.contains('confirmed')
                                                                                ? Icon(Icons.check_circle, size: 16, color: kColorPrimary)
                                                                                : Icon(Icons.error, size: 16, color: kRedColor),
                                                                            kTextHeader(
                                                                                myPackagesResponse.data?.orders?[index].paymentStatus == ""
                                                                                    ? ""
                                                                                    : myPackagesResponse.data!.orders![index].paymentStatus!.contains("confirmed")
                                                                                        ? "Successful"
                                                                                        : "Failed",
                                                                                bold: true,
                                                                                paddingH: 8,
                                                                                align: TextAlign.start,
                                                                                color: myPackagesResponse.data!.orders![index].paymentStatus!.contains('confirmed') ? kColorPrimary : kRedColor),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    myPackagesResponse.data?.orders?[index].paymentUrl ==
                                                                            null
                                                                        ? Expanded(
                                                                            child:
                                                                                Center(
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.pushReplacement(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (_) => InvoiceView(
                                                                                                packageId: myPackagesResponse.data?.orders?[index].id,
                                                                                              )));
                                                                                },
                                                                                child: Center(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: kColorPrimary, borderRadius: BorderRadius.circular(64), boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey.withOpacity(0.4),
                                                                                        blurRadius: 1,
                                                                                        spreadRadius: 1,
                                                                                        offset: Offset(0, 1),
                                                                                      ),
                                                                                    ]),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                                      child: kTextHeader(
                                                                                        "Details ",
                                                                                        size: 16,
                                                                                        color: Colors.white,
                                                                                        bold: true,
                                                                                        paddingH: 12,
                                                                                        paddingV: 4,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Expanded(
                                                                            child:
                                                                                Center(
                                                                              child: GestureDetector(
                                                                                onTap: myPackagesResponse.data?.orders?[index].paymentUrlStatus == true
                                                                                    ? () {
                                                                                        Navigator.pushReplacement(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (_) => WebViewScreen(
                                                                                                      url: myPackagesResponse.data!.orders![index].paymentUrl!,
                                                                                                      packageId: myPackagesResponse.data!.orders?[index].id!,
                                                                                                    )));
                                                                                      }
                                                                                    : () {
                                                                                        Fluttertoast.showToast(msg: "  Payment is deactivated  ");
                                                                                      },
                                                                                child: Center(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: myPackagesResponse.data?.orders?[index].paymentUrlStatus == true ? kColorPrimary : kColorAccent, borderRadius: BorderRadius.circular(64), boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.grey.withOpacity(0.4),
                                                                                        blurRadius: 1,
                                                                                        spreadRadius: 1,
                                                                                        offset: Offset(0, 1),
                                                                                      ),
                                                                                    ]),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                                      child: kTextHeader(
                                                                                        "Pay ",
                                                                                        size: 16,
                                                                                        color: Colors.white,
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
                                              separatorBuilder:
                                                  (context, index) =>
                                                      SizedBox(height: 12),
                                              itemCount: myPackagesResponse
                                                  .data!.orders!.length),
                                        ),
                                      ),
                                myPackagesResponse.data!.subscriptionStatus ==
                                        true
                                    ? GestureDetector(
                                        onTap: () async {
                                          Get.offNamed(
                                            Routes.SUBSCRIBE,
                                          );
                                        },
                                        child: Center(
                                          child: Container(
                                            width: Get.width / 1.4,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 16),
                                            decoration: BoxDecoration(
                                              color: Color(0xffFFB62B),
                                              borderRadius:
                                                  BorderRadius.circular(64),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                  blurRadius: 1,
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/img/premium.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                kTextHeader(
                                                    'Subscribe new package',
                                                    size: 16,
                                                    color: Colors.white,
                                                    bold: true,
                                                    paddingH: 16,
                                                    paddingV: 4),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : MainUnAuth(
                              isGuest: true,
                              paymentStatus:
                                  myPackagesResponse.data!.subscriptionStatus);
                },
              )),
        ),
      ),
    );
  }
}
