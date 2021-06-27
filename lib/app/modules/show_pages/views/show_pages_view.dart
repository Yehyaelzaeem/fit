import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/show_pages_controller.dart';

class ShowPagesView extends GetView<ShowPagesController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.reset();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
              onTap: () {
                controller.reset();
              },
              child: Text('reset')),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.selectedWidget.length > 0) return controller.selectedWidget[0].widget;

          return SingleChildScrollView(
            child: Column(
              children: [
                pages(),
                Divider(height: 3, color: kColorPrimary),
                widgets(),
                Divider(height: 3, color: kColorPrimary),
                defaultWidgets(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget pages() {
    return Column(
      children: [
        Container(width: double.infinity, child: kTextHeader('Pages')),
        Wrap(
          children: [
            ...controller.pages.map((singlePage) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(singlePage.route);
                },
                child: Container(
                  width: Get.width / 3.1,
                  child: Card(
                    color: singlePage.color,
                    child: kTextHeader(singlePage.pageName),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget widgets() {
    return Column(
      children: [
        Container(width: double.infinity, child: kTextHeader('Widgets')),
        Wrap(
          children: [
            ...controller.widgets.map((singlePage) {
              return GestureDetector(
                onTap: () {
                  controller.selectedWidget.add(singlePage);
                },
                child: Container(
                  width: Get.width / 3.1,
                  child: Card(
                    color: singlePage.color,
                    child: kTextHeader(singlePage.widgetName),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget defaultWidgets() {
    return Column(
      children: [
        Container(width: double.infinity, child: kTextHeader('default widgets')),
        Column(
          children: [
            ...controller.defaultWidgets.map((singlePage) {
              return singlePage;
            }),
          ],
        )
      ],
    );
  }
}
