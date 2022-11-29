import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/invoice_controller.dart';

class InvoiceView extends GetView<InvoiceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(children: [
        HomeAppbar(type: null),
        SizedBox(height: 8),
        PageLable(name: "Invoice"),
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Container(
            decoration: DottedDecoration(
              shape: Shape.box,
              color: kColorPrimary,
              borderRadius: BorderRadius.circular(24.0), //remove this to get plane rectange
            ),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0,vertical: 20),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  invoiceData('Order No',"4545"),
                  invoiceData('Service  Name',"Service  Name"),
                  invoiceData('Service Details',"Service Details"),
                  invoiceData('Price',"500 LE"),
                  invoiceData('Time',"5:44 PM"),
                  invoiceData('Date',"30 Dec 2022"),
                ],
              ),
              ),
            ),
          ),
        ),
      ])
    );
  }

  Widget invoiceData(String header ,String value) {
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
                          align: TextAlign.center,
                          color: Color(0xff7FC902),
                          bold: true),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: kTextHeader(value,
                          align: TextAlign.center,
                          color: Colors.black,
                          bold: true),
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
