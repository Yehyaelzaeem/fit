import 'dart:async';

import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/error_handler_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        title: Text(Strings().about),
        centerTitle: true,
      ),
      body: Obx(() {
        errorHandler(controller.error.value, controller);

     return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    '${controller.about.trim()}',
                  ),
                ),
              ],
            ),
          );
        
        // if (controller.response.value != null &&
        //     controller.response.value.data != null &&
        //     controller.response.value.data.text != null &&
        //     controller.response.value.data.text.isNotEmpty) {
        //   return SingleChildScrollView(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: HtmlWidget(
        //             '${controller.response.value.data.text.trim()}',
        //           ),
        //         ),
        //       ],
        //     ),
        //   );
        // }

        return CircularLoadingWidget();
      }),
    );
  }
}
