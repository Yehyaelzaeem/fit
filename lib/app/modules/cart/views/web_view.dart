import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/invoice/views/invoice_view.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/helper/assets_path.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/cart_controller.dart';

class WebViewScreen extends GetView<CartController> {
  final String url;
  final int? packageId;
  final String? fromCheerfull;

   WebViewScreen(
      {Key? key, required this.url, this.packageId, this.fromCheerfull})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("WEB URL =========== > $url");
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HomeAppbar(
              type: null,
            ),
            Expanded(
              child: Center(
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: url,
                  onPageStarted: (String link) {
                    print("WEB link =========== > $link");
                    if (link.contains("Success")) {
                      if (fromCheerfull != "From Cheerful Order") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    InvoiceView(packageId: packageId!)));
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
                                  Image.asset(kSuccessful,scale: 10,),
                                  SizedBox(height: 12),
                                  kTextbody(
                                      "  Payment Successful  ",
                                      color: Colors.black,
                                      bold: true,
                                      align: TextAlign.center),
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
                                  kTextbody(
                                      "Thank you for ordering from Cheer-Full \n \n 😍 Have a cheerful day 😍",
                                      color: Colors.black,
                                      bold: true,
                                      align: TextAlign.center),
                                  SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  onPageFinished: (String link) {
                    print("WEB link =========== > $link");
                    if (link.contains("Failed")) {
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
                                Image.asset(kFailed,scale: 10,),
                                SizedBox(height: 12),
                                kTextbody(
                                    "Payment Failed",
                                    color: Colors.black,
                                    bold: true,
                                    align: TextAlign.center),
                                SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      );                     // Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
