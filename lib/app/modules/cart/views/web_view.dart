import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/views/home_view.dart';
import 'package:app/app/modules/invoice/views/invoice_view.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/cart_controller.dart';

class WebViewScreen extends GetView<CartController> {
  final String url;
  final int? packageId;
  final String? fromCheerfull;
  FocusNode inputNode = FocusNode();
  void openKeyboard(context){
    FocusScope.of(context).requestFocus(inputNode);
  }
   WebViewScreen(
      {Key? key, required this.url, this.packageId, this.fromCheerfull})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    openKeyboard(context);
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
                      Fluttertoast.showToast(msg: "Payment Successful");
                      if (fromCheerfull != "From Cheerful Order") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    InvoiceView(packageId: packageId!)));
                      } else {
                        Get.offAllNamed(Routes.HOME);
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
                      Fluttertoast.showToast(msg: "Payment Failed");
                      Navigator.pop(context);
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
