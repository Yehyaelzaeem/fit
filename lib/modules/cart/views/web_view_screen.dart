/*
import 'dart:collection';
import 'dart:io';

import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/invoice/views/invoice_view.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final int? packageId;
  final String? fromCheerfull;

  WebViewScreen({Key? key, required this.url, this.packageId, this.fromCheerfull}) : super(key: key);

  // late PullToRefreshController pullToRefreshController;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

*/
/*  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: kColorPrimary,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );    super.initState();
  }*/ /*

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HomeAppbar(
              type: null,
            ),
            Expanded(
              child: Center(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(url)),
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  onWebViewCreated: (myController) async {
                    webViewController = myController;
                    print(await myController.getUrl());
                  },
                  initialOptions: options,
                  //   pullToRefreshController: pullToRefreshController,
                  onLoadError: (ctrl, url, code, message) {
                    //     pullToRefreshController.endRefreshing();
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    final uri = navigationAction.request.url!;
                    print("uri = " + uri.toString());
                    print("on ShouldOverrideUrlLoading ===>${uri.path}");
                    if (Platform.isIOS) {
                      if (uri.path == 'https://fofclinic.com/Payment-Success' || uri.path.toLowerCase().contains("success") || uri.path.toLowerCase().contains("Payment-Success")) {
                        if (fromCheerfull != "From Cheerful Order") {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InvoiceView(packageId: packageId!)));
                          Get.dialog(
                            Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 12),
                                    Image.asset(
                                      kSuccessful,
                                      scale: 10,
                                    ),
                                    SizedBox(height: 12),
                                    kTextbody("  Payment Successful  ", color: Colors.black, bold: true, align: TextAlign.center),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          Get.offNamed(Routes.ORDERS);
                          Get.dialog(
                            Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 12),
                                    kTextbody("Thank you for ordering from Cheer-Full \n \n 😍 Have a cheerful day 😍", color: Colors.black, bold: true, align: TextAlign.center),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      } else if (uri.path.toLowerCase().contains("failed")) {
                        print("Failed ${uri.path}");
                        Get.dialog(
                          Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 12),
                                  Image.asset(
                                    kFailed,
                                    scale: 10,
                                  ),
                                  SizedBox(height: 12),
                                  kTextbody("Payment Failed", color: Colors.black, bold: true, align: TextAlign.center),
                                  SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStart: (webViewController, uri) {
                  },
                  */
/*    onLoadStop: (ctrl, url) async {
                    print("on load stop ===>$url");
                    //     pullToRefreshController.endRefreshing();
                  },*/ /*

                  */
/*   onPageFinished: (String link) {
                    print("WEB link =========== > $link");

                  },*/ /*

                  */
/*  shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
                      return ShouldOverrideUrlLoadingAction.ALLOW;
                    }*/ /*

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
