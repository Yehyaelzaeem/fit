
import 'package:app/config/navigation/navigation.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../config/navigation/routes.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../../packages/cubits/packages_cubit.dart';
import '../controllers/invoice_controller.dart';

class InvoiceView extends StatefulWidget {
  final int? packageId;

  InvoiceView({Key? key, this.packageId}) : super(key: key);
  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {

  late final PackagesCubit packagesCubit;


  @override
  void initState() {
    packagesCubit = BlocProvider.of<PackagesCubit>(context);
    packagesCubit.getPackageDetails(packageId: widget.packageId!);

    super.initState();
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    await NavigationService.push(context,Routes.myPackagesView,);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return _willPopCallback(context);
      },
      child: Scaffold(
          body: widget.packageId == null
              ?

              Center(child: kTextHeader("Error loading order details"))
            : BlocConsumer<PackagesCubit, PackagesState>(
              listener: (BuildContext context, PackagesState state) {

              },
              builder: (context, state) => state is PackageLoading
                  ? Center(child: CircularLoadingWidget()):
              state is PackageDetailsLoaded?ListView(children: [
                HomeAppbar(fromInvoice: true,type: null,onBack:() {
                  NavigationService.push(context,Routes.myPackagesView,);
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
                          24.0),
                    ),
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 26.0, vertical: 20),
                        child:  Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              invoiceData(
                                  'Order No',
                                  state.packageDetails
                                      .data?.orderId
                                      .toString() ??
                                      ""),
                              invoiceData(
                                  'Service Name',
                                  state.packageDetails
                                      .data?.name ??
                                      ""),
                              invoiceData(
                                  'Duration',
                                  state.packageDetails
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
                                      color: AppColors.kGreyContainerBackground,
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
                                      data: state.packageDetails
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
                                  "${state.packageDetails.data?.price.toString() ?? state.packageDetails.data?.usdPrice.toString() ?? ""} ${state.packageDetails.data?.price.toString() != null ? "LE" : "\$"}"),
                              invoiceData(
                                'Time',
                                state.packageDetails.data
                                    ?.time ??
                                    "",
                              ),
                              invoiceData(
                                'Date',
                                state.packageDetails.data
                                    ?.date ??
                                    "",
                              ),
                            ],
                          ),

                      ),
                    ),
                  ),
                ),
              ]):SizedBox()
                  ,)

                )

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
            color: AppColors.kGreyContainerBackground,
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
