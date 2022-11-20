/*
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/cart_controller.dart';


class WebViewScreen extends GetView<CartController>  {
  final String url;
  const WebViewScreen({Key? key,required this.url}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return SafeArea(
      //url.contains('/app_order')? 'www.google.com':
      child: Scaffold(
        appBar: HomeAppbar(),
        body: WebView(
           javascriptMode: JavascriptMode.unrestricted,
          initialUrl: url,
          onPageFinished: (String link){
         //    print(link);
       //     link == "https://zoe.com.sa/zoe-dev/public/en/app_order"
             if(link.contains("app_order")){
               controller.clearCart();
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LayoutView()), (route) => false);
             }else if(link =="https://zoe.com.sa/api/app_order"){
               controller.clearCart();
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LayoutView()), (route) => false);
             }
          },
        ),
      ),
    );
  }
}
*/
