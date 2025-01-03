import 'dart:io';

import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/resources/app_values.dart';
import 'package:app/core/utils/globals.dart';
import 'package:app/modules/subscribe/cubits/subscribe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../cart/views/web_view.dart';
import '../../home/view/widgets/home_appbar.dart';
import 'non_user_subscribe_view.dart';

class SubscribeView extends StatefulWidget {
@override
State<SubscribeView> createState() => _MySubscribeViewState();
}

class _MySubscribeViewState extends State<SubscribeView> {
  late final SubscribeCubit subscribeCubit;
  PageController pc = new PageController(viewportFraction: 0.8);

  @override
  void initState() {
    subscribeCubit = BlocProvider.of<SubscribeCubit>(context);
    subscribeCubit.fetchServices();

  }

  List<String> result = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body:


            BlocBuilder<SubscribeCubit, SubscribeState>(
        builder: (context, state)
    {
      if (state is ServicesLoading) {
        return Center(child: CircularLoadingWidget());
      }
      if (state is ServicesError) {
        return errorHandler(state.message, context);
      }
      if (state is ServicesLoaded) {
        final servicesResponse = state.servicesResponse;
        return SizedBox(
          height: deviceHeight,
          child: Column(
            children: [
              //App bar
              HomeAppbar(),
              SizedBox(height: 12),
              Container(
                height: deviceHeight * 0.2,
                child: ListView.builder(
                    itemCount: subscribeCubit.servicesResponse.data!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          subscribeCubit.selectedIndex(index);
                          setState(() {

                          });
                        },
                        child: Container(
                          height: deviceHeight * 0.12,
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
                                    color: subscribeCubit
                                        .serviceIndex ==
                                        index
                                        ? kColorPrimary
                                        : Colors.transparent,
                                    width: subscribeCubit
                                        .serviceIndex ==
                                        index
                                        ? 1
                                        : 1,
                                  ),
                                  boxShadow: [
                                    if (subscribeCubit
                                        .serviceIndex ==
                                        index)
                                      BoxShadow(
                                        color: kColorPrimary,
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, 0),
                                      ),
                                    if (subscribeCubit
                                        .serviceIndex !=
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
                                  "${subscribeCubit.servicesResponse
                                      .data![index].image}",
                                  width: 50,
                                  height: 40,
                                ),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width /
                                    3.2,
                                child: kTextHeader(
                                    subscribeCubit.servicesResponse
                                        .data![index].name!,
                                    bold: true,
                                    size: 12,
                                    color: subscribeCubit
                                        .serviceIndex ==
                                        index
                                        ? kColorPrimary
                                        : Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),

              subscribeCubit
                  .servicesResponse
                  .data?[subscribeCubit.serviceIndex]
                  .packages
                  ?.length !=
                  0
                  ? Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedBuilder(
                        animation: pc,
                        builder: (context1, child) {
                          final payment = subscribeCubit
                              .servicesResponse
                              .data?[subscribeCubit.serviceIndex]
                              .packages;
                          return PageView.builder(
                            controller: pc,
                            onPageChanged: (value) {
                              subscribeCubit.currentPageIndex =
                                  pc.page!.round();
                            },
                            itemCount: subscribeCubit
                                .servicesResponse
                                .data?[subscribeCubit.serviceIndex]
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
                                    vertical: AppSize.s40),
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
                                                      "${subscribeCubit
                                                          .servicesResponse
                                                          .data?[subscribeCubit
                                                          .serviceIndex]
                                                          .packages?[i].price ??
                                                          ""}",
                                                      size: 22,
                                                      bold: true,
                                                      white: true),
                                                  kTextHeader(
                                                      subscribeCubit
                                                          .servicesResponse
                                                          .data?[subscribeCubit
                                                          .serviceIndex]
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
                                                  subscribeCubit
                                                      .servicesResponse
                                                      .data?[subscribeCubit
                                                      .serviceIndex
                                                  ]
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
                                        data: subscribeCubit
                                            .servicesResponse
                                            .data?[subscribeCubit
                                            .serviceIndex
                                        ]
                                            .packages?[i]
                                            .description ??
                                            "",
                                      ),
                                    ),
                                    if (payment?[i].visaPayments !=
                                        null &&
                                        payment?[i].visaPayments ==
                                            true)
                                      subscribeCubit.isPaymentVisaClicked
                                          ==
                                          false
                                          ? kButton("Payment",
                                          color: kColorPrimary,
                                          func: subscribeCubit
                                              .servicesResponse
                                              .data?[subscribeCubit
                                              .serviceIndex
                                          ]
                                              .packages?[i]
                                              .paymentStatus ==
                                              true
                                              ?
                                              () async {
                                            if (await subscribeCubit
                                                .getFromCash() ==
                                                "haveAllData") {
                                              subscribeCubit
                                                  .makePackagePayment(
                                                  name: currentUser!.data!.name??'',
                                                  phone: currentUser!.data!.phone??'',
                                                  lastName: currentUser!.data!.lastName??'',
                                                  email: currentUser!.data!.email??'',
                                                  packageId: subscribeCubit
                                                      .servicesResponse
                                                      .data![subscribeCubit.serviceIndex]
                                                      .packages![i]
                                                      .id!,
                                                  payMethod:
                                                  "visa",
                                                  isGuest: false)
                                                  .then((value) async{

                                                NavigationService
                                                    .pushReplacement(
                                                  context,
                                                    Routes.webView
                                                    ,
                                                  arguments: {
                                                    "url": subscribeCubit
                                                        .packagePaymentResponse
                                                        .data!
                                                        .paymentUrl!,
                                                    "packageId":
                                                    subscribeCubit
                                                        .packagePaymentResponse
                                                        .data!
                                                        .id!,
                                                  }
                                                );
                                              });
                                            } else if (await subscribeCubit
                                                .getFromCash() ==
                                                "noLastName") {
                                              NavigationService.push(context,
                                                  Routes.editProfileScreen);
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
                                      subscribeCubit.isPaymentAppleClicked
                                          ==
                                          false
                                          ? kButton("Check out with",
                                          color: Colors.black,
                                          func: subscribeCubit
                                              .servicesResponse
                                              .data?[subscribeCubit
                                              .serviceIndex
                                          ]
                                              .packages?[i]
                                              .paymentStatus ==
                                              true
                      
                                              ? () async {
                                            if (await subscribeCubit
                                                .getFromCash() ==
                                                "haveAllData") {
                                              subscribeCubit
                                                  .makePackagePayment(
                                                  name: currentUser!.data!.name??'',
                                                  phone: currentUser!.data!.phone??'',
                                                  lastName: currentUser!.data!.lastName??'',
                                                  email: currentUser!.data!.email??'',
                      
                                                  packageId: subscribeCubit
                                                      .servicesResponse
                                                      .data![subscribeCubit
                                                      .serviceIndex
                                                  ]
                                                      .packages![
                                                  i]
                                                      .id!,
                                                  payMethod:
                                                  "apple_pay",
                                                  isGuest: false
                                              )
                                                  .then((value) {
                                                ///TODO HandleApplePay
                      
                      
                                                Fluttertoast.showToast(
                                                    msg:
                                                    " HandleApplePay ");
                                              });
                                            } else if (await subscribeCubit
                                                .getFromCash() ==
                                                "noLastName") {
                                              NavigationService.push(context,
                                                  Routes.editProfileScreen);
                                            } else {
                                              _navigateAndDisplaySelection(
                                                  context: context,
                                                  i: i);
                                            }
                                          } : () {
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
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: pc,
                      count: subscribeCubit
                          .servicesResponse
                          .data?[subscribeCubit.serviceIndex]
                          .packages?.length??0,
                      effect: const ColorTransitionEffect(
                        activeDotColor: AppColors.primary,
                        dotColor: AppColors.lightGrey,
                        dotWidth: AppSize.s8,
                        spacing: AppSize.s4,
                        dotHeight: AppSize.s8,
                      ),
                    ),

                  ],
                ),
              )
                  : Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.2),
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

              SizedBox(height: AppSize.s48),
            ],
          ),
        );
      }

      return SizedBox();
  } ),
      ),
    ));
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

    subscribeCubit
        .makePackagePayment(
            name: result[0],
            lastName: result[1],
            email: result[2],
            phone: result[3],
            packageId: subscribeCubit.servicesResponse
                .data![subscribeCubit.serviceIndex].packages![i].id!,
            payMethod: '',
    isGuest: true
    )
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: subscribeCubit.packagePaymentResponse.data!.paymentUrl!,
            packageId: subscribeCubit.packagePaymentResponse.data!.id!,
          ),
        ),
      );
    });
  }
}
