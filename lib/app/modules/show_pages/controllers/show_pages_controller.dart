import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/auth_error.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/empty_error.dart';
import 'package:app/app/widgets/default/message_error.dart';
import 'package:app/app/widgets/default/no_internet_conn.dart';
import 'package:app/app/widgets/default/server_error.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPagesController extends GetxController {
  List<PageView> pages = [];
  List<WidgetView> widgets = [];

  List<Widget> defaultWidgets = [];
  RxList<WidgetView> selectedWidget = RxList();
  String text =
      'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى';

  init() {
    pages.clear();
    widgets.clear();
    defaultWidgets.clear();

    pages.add(PageView(
        pageName: "Intro",
        route: Routes.INTRODUCTION_SCREEN,
        color: Colors.white));
    pages.add(PageView(
        pageName: "About", route: Routes.ABOUT, color: Colors.greenAccent));
    pages.add(PageView(
        pageName: "Policy", route: Routes.POLICY, color: Colors.redAccent));

    widgets.add(WidgetView(
        widgetName: "Auth err",
        widget: AuthErrorWidget(refresh: () {}),
        color: Colors.red));
    widgets.add(WidgetView(
        widgetName: "Server err",
        widget: ServerErrorWidget(refresh: () {}),
        color: Colors.orange));
    widgets.add(WidgetView(
        widgetName: "Network err",
        widget: NoInternetConnection(refresh: () {}),
        color: Colors.redAccent));
    widgets.add(WidgetView(
        widgetName: "Empty err",
        widget: EmptyErrorWidget(refresh: () {}),
        color: Colors.blueAccent));
    widgets.add(WidgetView(
        widgetName: "Message err",
        widget: MessageErrorWidget(message: text, refresh: () {}),
        color: Colors.greenAccent));

    defaultWidgets.add(EditText(value: 'value', hint: 'hint'));
    defaultWidgets.add(kTextHeader(text));
    defaultWidgets.add(kTextbody(text));
    defaultWidgets.add(kTextfooter(text));
    defaultWidgets.add(kButton('button', func: () {}));
    defaultWidgets.add(kButton('button', func: () {}, loading: true));
    defaultWidgets.add(kButtonDefault('button', func: () {}, loading: false));
    defaultWidgets.add(kButtonDefault('button', func: () {}, loading: true));

    selectedWidget.clear();
  }

  @override
  void onInit() {
    super.onInit();

    init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void reset() {
    init();
  }
}

class PageView {
  late String pageName;
  late String route;
  late Color color;

  PageView({required this.pageName, required this.color, required this.route});
}

class WidgetView {
  late String widgetName;
  late Widget widget;
  late Color color;

  WidgetView(
      {required this.widgetName, required this.color, required this.widget});
}
