import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../network_util/shared_helper.dart';
import '../../../routes/app_pages.dart';
import '../../myPackages/views/my_packages_view.dart';
import '../controllers/invoice_controller.dart';

class InvoiceView extends GetView<InvoiceController> {
  final int? packageId;

  InvoiceView({Key? key, this.packageId}) : super(key: key);


  Future<bool> _willPopCallback() async {
    await Get.toNamed(Routes.MY_PACKAGES,);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //  controller.getPackageDetails(packageId: packageId!);
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
          body: packageId == null
              ?

              Center(child: kTextHeader("Error loading order details"))
            : Obx(() {
                  if (controller.loading.value)
                    return Center(child: CircularLoadingWidget());
                  if (controller.error.value.isNotEmpty)
                    return errorHandler(controller.error.value, controller);
                  return FutureBuilder(
                      future: controller.getPackageDetails(packageId: packageId!),
                      builder: (ctx, data) {
                        if (data.connectionState == ConnectionState.waiting ||
                            data.hasError) {
                          return Center(
                            child: CircularLoadingWidget(),
                          );
                        } else {
                          return ListView(children: [
                            HomeAppbar(fromInvoice: true,type: null,onBack:() {
                              Get.toNamed(Routes.MY_PACKAGES,);
                            },),
                            SizedBox(height: 8),
                            PageLable(name: "Invoice"),
                            Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Container(
                                decoration: DottedDecoration(
                                  shape: Shape.box,
                                  color: kColorPrimary,
                                  borderRadius: BorderRadius.circular(
                                      24.0), //remove this to get plane rectange
                                ),
                                child: Card(
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 26.0, vertical: 20),
                                    child: GetBuilder<InvoiceController>(
                                      builder: (_) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          invoiceData(
                                              'Order No',
                                              controller.packageDetailsResponse
                                                      .data?.orderId
                                                      .toString() ??
                                                  ""),
                                          invoiceData(
                                              'Service Name',
                                              controller.packageDetailsResponse
                                                      .data?.name ??
                                                  ""),
                                          invoiceData(
                                              'Duration',
                                              controller.packageDetailsResponse
                                                      .data?.package ??
                                                  ""),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: kGreyContainerBackground,
                                                ),
                                                child: kTextHeader('Details',
                                                    align: TextAlign.center,
                                                    color: Color(0xff7FC902),
                                                    bold: true),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                                child: Html(
                                                  data: controller
                                                      .packageDetailsResponse
                                                      .data!
                                                      .description,
                                                ),
                                              ),
                                              Divider(
                                                indent: 20,
                                                endIndent: 20,
                                                color: Colors.black45,
                                                thickness: 1,
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          ),
                                          invoiceData('Price',
                                              "${controller.packageDetailsResponse.data?.price.toString() ?? controller.packageDetailsResponse.data?.usdPrice.toString() ?? ""} ${controller.packageDetailsResponse.data?.price.toString() != null ? "LE" : "\$"}"),
                                          invoiceData(
                                            'Time',
                                            controller.packageDetailsResponse.data
                                                    ?.time ??
                                                "",
                                          ),
                                          invoiceData(
                                            'Date',
                                            controller.packageDetailsResponse.data
                                                    ?.date ??
                                                "",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }
                      });
                })
          ),
    );
  }

  Widget invoiceData(String header, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: kGreyContainerBackground,
          ),
          child: kTextHeader(header,
              align: TextAlign.center, color: Color(0xff7FC902), bold: true),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: kTextHeader(value,
              align: TextAlign.center, color: Colors.black, bold: true),
        ),
        Divider(
          indent: 20,
          endIndent: 20,
          color: Colors.black45,
          thickness: 1,
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
