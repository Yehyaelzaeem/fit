import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/home/views/home_view.dart';
import 'package:app/app/modules/invoice/views/invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/cart_controller.dart';


class WebViewScreen extends GetView<CartController>  {
  final String url;
  const WebViewScreen({Key? key,required this.url}) : super(key: key);

 @override
  Widget build(BuildContext context) {
   print("WEB URL =========== > $url");
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HomeAppbar(type: null,),
            Expanded(
              child: WebView(
                 javascriptMode: JavascriptMode.unrestricted,
                initialUrl: url,
                onPageStarted:(String link){
                  print("WEB link =========== > $link");
                  if(link.contains("Order-Payment")){
                    Fluttertoast.showToast(msg: "Loading .. ");
                  }else  if(link.contains("Payment-Success")){
                    Fluttertoast.showToast(msg: link.split("/").last);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>InvoiceView()),);
                  }
                },
                onPageFinished: (String link){
                  print("WEB link =========== > $link");
                  if(link.contains("Failed")) {
                    Fluttertoast.showToast(msg: link.split("/").last);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
