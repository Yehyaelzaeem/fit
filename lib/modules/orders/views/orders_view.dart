

import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/resources.dart';
import 'package:app/modules/orders/cubits/order_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/my_orders_response.dart';
import '../../../core/utils/globals.dart';
import '../../../core/view/widgets/default/edit_text.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cart/views/web_view.dart';

class OrdersView extends StatefulWidget {
  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  late final OrdersCubit ordersCubit;


  @override
  void initState() {
    super.initState();
    ordersCubit = BlocProvider.of<OrdersCubit>(context);
    ordersCubit.fetchMyOrders();

  }
  
  Widget appBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: deviceWidth,
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
              AppImages.kLogoChellFullRow,
              height: 44,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () {
                NavigationService.goBack(context);
                NavigationService.goBack(context);
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

  Future<bool> _willPopCallback() async {
    NavigationService.goBack(context);
    NavigationService.goBack(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorPrimary,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: _willPopCallback,
          child: Scaffold(
              backgroundColor: Colors.white,
              body: ListView(children: [
                appBar(context),
                SizedBox(height: 12),
                PageLable(name: "My Orders"),
                SizedBox(height: 12),
                BlocConsumer<OrdersCubit, OrdersState>(
                  listener: (BuildContext context, OrdersState state) {

                  },
                  builder: (context, state) {
                    if (state is OrdersLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is OrdersLoaded) {
                      return Column(
                        children: [
                          Container(
                            height: 35,
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
                                      ordersCubit.selectedTap = 2;
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: ordersCubit.selectedTap == 2
                                            ? Colors.white
                                            : Color(0xFF414042),
                                        borderRadius: BorderRadius.circular(200),
                                      ),
                                      child: kTextbody(
                                        "Pending",
                                        paddingV: 8,
                                        color: ordersCubit.selectedTap == 2
                                            ? kColorPrimary
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ordersCubit.selectedTap = 1;
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: ordersCubit.selectedTap == 1
                                            ? Colors.white
                                            : Color(0xFF414042),
                                        borderRadius: BorderRadius.circular(200),
                                      ),
                                      child: kTextbody(
                                        "Accepted",
                                        paddingV: 8,
                                        color: ordersCubit.selectedTap == 1
                                            ? kColorPrimary
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (ordersCubit.selectedTap == 2)
                            state.pendingOrders.length == 0
                                ? buildEmpty()
                                : SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                  itemCount: state.pendingOrders.length,
                                  itemBuilder: (context, index) =>
                                      singleOrderCard(
                                          state.pendingOrders[index],
                                          context)),
                            ),
                          if (ordersCubit.selectedTap == 1)
                            state.completedOrders.length == 0
                                ? buildEmpty()
                                : SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                  itemCount: state.completedOrders.length,
                                  itemBuilder: (context, index) =>
                                      singleOrderCard(
                                          state.completedOrders[index],
                                          context)),
                            )
                        ],
                      );
                      // return Column(
                      //   children: [
                      //     Container(
                      //       height: 35,
                      //       decoration: BoxDecoration(
                      //         color: Color(0xFF414042),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Color(0xFF414042),
                      //             blurRadius: 5,
                      //             spreadRadius: 1,
                      //             offset: Offset(0, 0),
                      //           ),
                      //         ],
                      //         borderRadius: BorderRadius.circular(200),
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           Expanded(
                      //             child: GestureDetector(
                      //               onTap: () {
                      //                 // Handle tab switch to pending orders
                      //               },
                      //               child: Container(
                      //                 height: 35,
                      //                 alignment: Alignment.center,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   borderRadius: BorderRadius.circular(200),
                      //                 ),
                      //                 child: Text("Pending"),
                      //               ),
                      //             ),
                      //           ),
                      //           Expanded(
                      //             child: GestureDetector(
                      //               onTap: () {
                      //                 // Handle tab switch to completed orders
                      //               },
                      //               child: Container(
                      //                 height: 35,
                      //                 alignment: Alignment.center,
                      //                 decoration: BoxDecoration(
                      //                   color: Color(0xFF414042),
                      //                   borderRadius: BorderRadius.circular(200),
                      //                 ),
                      //                 child: Text("Completed", style: TextStyle(color: Colors.white)),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     state.pendingOrders.isEmpty
                      //         ? Center(child: Text("No Pending Orders"))
                      //         : ListView.builder(
                      //       itemCount: state.pendingOrders.length,
                      //       itemBuilder: (context, index) {
                      //         return ListTile(
                      //           title: Text(state.pendingOrders[index].name),
                      //           subtitle: Text(state.pendingOrders[index].details),
                      //         );
                      //       },
                      //     ),
                      //     state.completedOrders.isEmpty
                      //         ? Center(child: Text("No Completed Orders"))
                      //         : ListView.builder(
                      //       itemCount: state.completedOrders.length,
                      //       itemBuilder: (context, index) {
                      //         return ListTile(
                      //           title: Text(state.completedOrders[index].name),
                      //           subtitle: Text(state.completedOrders[index].details),
                      //         );
                      //       },
                      //     ),
                      //   ],
                      // );
                    } else if (state is OrdersError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }

                    return Container();
                  },
                ),
                // Obx(() {
                //   if (!controller.loading.value)
                //     return Center(child: CircularLoadingWidget());
                //   return Column(
                //     children: [
                //       Container(
                //         height: 35,
                //         decoration: BoxDecoration(
                //           color: Color(0xFF414042),
                //           boxShadow: [
                //             BoxShadow(
                //               color: Color(0xFF414042),
                //               blurRadius: 5,
                //               spreadRadius: 1,
                //               offset: Offset(0, 0),
                //             ),
                //           ],
                //           borderRadius: BorderRadius.circular(200),
                //         ),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: GestureDetector(
                //                 onTap: () {
                //                   controller.selectedTap.value = 2;
                //                 },
                //                 child: Container(
                //                   height: 35,
                //                   alignment: Alignment.center,
                //                   decoration: BoxDecoration(
                //                     color: controller.selectedTap.value == 2
                //                         ? Colors.white
                //                         : Color(0xFF414042),
                //                     borderRadius: BorderRadius.circular(200),
                //                   ),
                //                   child: kTextbody(
                //                     "Pending",
                //                     paddingV: 8,
                //                     color: controller.selectedTap.value == 2
                //                         ? kColorPrimary
                //                         : Colors.white,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             Expanded(
                //               child: GestureDetector(
                //                 onTap: () {
                //                   controller.selectedTap.value = 1;
                //                 },
                //                 child: Container(
                //                   height: 35,
                //                   alignment: Alignment.center,
                //                   decoration: BoxDecoration(
                //                     color: ordersCubit.selectedTap == 1
                //                         ? Colors.white
                //                         : Color(0xFF414042),
                //                     borderRadius: BorderRadius.circular(200),
                //                   ),
                //                   child: kTextbody(
                //                     "Accepted",
                //                     paddingV: 8,
                //                     color: controller.selectedTap.value == 1
                //                         ? kColorPrimary
                //                         : Colors.white,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       if (controller.selectedTap.value == 2)
                //         controller.pending.length == 0
                //             ? buildEmpty()
                //             : SizedBox(
                //                 height: MediaQuery.of(context).size.height,
                //                 child: ListView.builder(
                //                     itemCount: controller.pending.length,
                //                     itemBuilder: (context, index) =>
                //                         singleOrderCard(
                //                             controller.pending[index],
                //                             context)),
                //               ),
                //       if (controller.selectedTap.value == 1)
                //         controller.completed.length == 0
                //             ? buildEmpty()
                //             : SizedBox(
                //                 height: MediaQuery.of(context).size.height,
                //                 child: ListView.builder(
                //                     itemCount: controller.completed.length,
                //                     itemBuilder: (context, index) =>
                //                         singleOrderCard(
                //                             controller.completed[index],
                //                             context)),
                //               )
                //     ],
                //   );
                // }),
              ])),
        ),
      ),
    );
  }

  Widget buildEmpty() {
    return Padding(
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
          kTextbody("  Empty!  ", size: 16),
        ],
      ),
    );
  }

  Widget singleOrderCard(Completed e, BuildContext context) {
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
                  ordersCubit.getMealsName(e.meals.reversed.toList()),
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
                  kTextbody("${getDelivertMethod(e.deliveryMethod)}",
                      color: Colors.black, bold: true),
                  kTextbody("${e.date}", color: Colors.black),
                  kTextbody("${e.status}", color: Colors.grey),
                  e.visaPaymentStatus == true
                      ? kTextbody("Payment Successful", color: Colors.grey)
                      : GestureDetector(
                          onTap: e.paymentUrl == ''
                              ? () {
                                  Fluttertoast.showToast(
                                      msg: "  Payment is deactivated  ");
                                }
                              : () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => WebViewScreen(
                                                url: e.paymentUrl,
                                                fromCheerfull:
                                                    "From Cheerful Order",
                                              )));
                                  //   print("result =>>>>>>>> $result");
                                },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.black, width: 1.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: kTextbody('Payment Failed',
                                  color: AppColors.kRedColor, paddingV: 2)),
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: Color(0xffF6F6F6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300]!,
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                      offset: Offset(3, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    kTextbody(
                                      "Delivery method :",
                                      color: kColorPrimary,
                                      bold: true,
                                      align: TextAlign.start,
                                    ),
                                    Expanded(
                                        child: kTextbody(
                                      "${getDelivertMethod(e.deliveryMethod.trim())}",
                                      color: Colors.black,
                                      align: TextAlign.start,
                                    )),
                                  ],
                                ),
                              ),
                              if (e.userInfo != null &&
                                  e.userInfo!.address.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffF6F6F6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      kTextbody(
                                        "Address :",
                                        color: kColorPrimary,
                                        bold: true,
                                        align: TextAlign.start,
                                      ),
                                      if (e.deliveryMethod == 'Delivery' ||
                                          e.deliveryMethod == 'delivery')
                                        Expanded(
                                            child: kTextbody(
                                          '${e.userInfo!.address}',
                                          color: Colors.black,
                                          align: TextAlign.start,
                                        )),
                                      if (e.deliveryMethod != 'Delivery' &&
                                          e.deliveryMethod != 'delivery')
                                        Expanded(
                                            child: kTextbody(
                                          '${mealFeatureHomeResponse.data!.info!.address!}',
                                          color: Colors.black,
                                          align: TextAlign.start,
                                        )),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 12),
                              // if (e.deliveryMethod != 'Delivery' && e.deliveryMethod != 'delivery') kTextbody(controller.globalController.mealFeatureHomeResponse.value.data!.info!.address!),

                              if ((e.deliveryMethod != 'Delivery' ||
                                      e.deliveryMethod != 'delivery') &&
                                  mealFeatureHomeResponse
                                          .data !=
                                      null &&
                                  mealFeatureHomeResponse
                                          .data!
                                          .info !=
                                      null &&
                                  mealFeatureHomeResponse
                                          .data!
                                          .info!
                                          .pickupLocation !=
                                      null &&
                                  mealFeatureHomeResponse
                                      .data!
                                      .info!
                                      .pickupLocation!
                                      .isNotEmpty)
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (e.deliveryMethod == 'Delivery' ||
                                          e.deliveryMethod == 'delivery') {
                                        if (e.userInfo != null &&
                                            e.userInfo!.latitude != null) {
                                          String lat =
                                              e.userInfo!.latitude.toString();
                                          String lng =
                                              e.userInfo!.longitude.toString();
                                          launch(
                                              'http://www.google.com/maps/place/$lat,$lng');
                                        }
                                      } else {
                                        String lat =
                                            e.userInfo!.latitude.toString();
                                        String lng =
                                            e.userInfo!.longitude.toString();
                                        launch(
                                            'http://www.google.com/maps/place/$lat,$lng');

                                        String location = "";

                                        if (mealFeatureHomeResponse
                                                .data !=
                                            null) {
                                          if (mealFeatureHomeResponse
                                                  .data!
                                                  .info !=
                                              null) {
                                            if (mealFeatureHomeResponse
                                                    .data!
                                                    .info!
                                                    .pickupLocation !=
                                                null) {
                                              location = mealFeatureHomeResponse
                                                  .data!
                                                  .info!
                                                  .pickupLocation!;
                                            }
                                          }
                                        }
                                        launch(location);
                                      }
                                    },
                                    child: Container(
                                      width: deviceWidth / 1.6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: kColorPrimary),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment(0.0, 0.1),
                                            child: SvgPicture.string(
                                              // Icon material-location-on
                                              '<svg viewBox="130.4 401.0 11.2 16.0" ><path transform="translate(122.9, 398.0)" d="M 13.10000038146973 3 C 10.00399971008301 3 7.5 5.504000186920166 7.5 8.600000381469727 C 7.5 12.80000019073486 13.10000038146973 19 13.10000038146973 19 C 13.10000038146973 19 18.70000076293945 12.80000019073486 18.70000076293945 8.600000381469727 C 18.70000076293945 5.504000186920166 16.19600105285645 3 13.10000038146973 3 Z M 13.10000038146973 10.60000038146973 C 11.99600028991699 10.60000038146973 11.10000038146973 9.703999519348145 11.10000038146973 8.600000381469727 C 11.10000038146973 7.49600076675415 11.99600028991699 6.600000381469727 13.10000038146973 6.600000381469727 C 14.20400047302246 6.600000381469727 15.10000038146973 7.49600076675415 15.10000038146973 8.600000381469727 C 15.10000038146973 9.703999519348145 14.20400047302246 10.60000038146973 13.10000038146973 10.60000038146973 Z" fill="#7fc902" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                              width: 11.2,
                                              height: 16.0,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Location',
                                            style: GoogleFonts.cairo(
                                              fontSize: 19.0,
                                              color: const Color(0xFF7FC902),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                      child: kTextbody("Location",
                          color: Colors.white, paddingV: 8)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 8),
                              ...e.meals.reversed.map((element) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: Color(0xffF6F6F6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      kTextbody(element.name,
                                          color: kColorPrimary,
                                          bold: true,
                                          align: TextAlign.start),
                                      kTextbody("${element.price} L.E",
                                          color: Colors.black, bold: true),
                                    ],
                                  ),
                                );
                              }).toList(),
                              Container(
                                width: double.infinity,
                                child: kTextbody("Instructions",
                                    size: 18,
                                    align: TextAlign.start,
                                    paddingH: 12),
                              ),
                              SizedBox(height: 6),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                      offset: Offset(3, 3),
                                    ),
                                  ],
                                ),
                                child: EditText(
                                  value: getInsturctions(e.deliveryMethod),
                                  hintColor: Color(0xff8D8D8D),
                                  enable: false,
                                  background: Color(0xffF6F6F6),
                                  updateFunc: (value) {},
                                  noBorder: true,
                                  radius: 4,
                                  lines: 0,
                                ),
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
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
                      child: kTextbody("Details",
                          color: Colors.black, paddingV: 8)),
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
    if (mealFeatureHomeResponse.data == null)
      return "";
    if (mealFeatureHomeResponse.data!.info ==
        null) return "";
    if (deliveryMethod == 'Delivery' || deliveryMethod == 'delivery') {
      instructions =
          "${mealFeatureHomeResponse.data!.info!.deliveryInstructions}";
    } else {
      instructions =
          "${mealFeatureHomeResponse.data!.info!.pickupInstructions}";
    }
    return instructions;
  }
}
