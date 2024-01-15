
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/helper/echo.dart';



class WebViewScreen extends StatefulWidget {
  final String _url;


  @override
  _WebViewScreenState createState() => _WebViewScreenState();

  const WebViewScreen({super.key,
    required String url,
  }) :
        _url = url;

}



class _WebViewScreenState extends State<WebViewScreen> {
 // final _tag = 'WebViewScreen';


  @override
  void initState() {
    Echo(widget._url);
    super.initState();
  }
  int _stackToView = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(centerTitle: true,title: Text("Video" , style: TextStyle(fontSize: 15),),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(child: _buildOnlineView()),

          Padding(padding: EdgeInsets.symmetric(vertical: 10))

        ],
      ),
    );
  }
  _buildOnlineView() {

    return  IndexedStack(
      index: _stackToView,
      children: [
        WebView(
          debuggingEnabled: true,
          onWebViewCreated: (v) {return;},
          initialUrl: widget._url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          onPageStarted: (String url) {Echo('onPageStarted $url');},
          onPageFinished: (String url) {setState(() {_stackToView = 0;});Echo('onPageFinished $url');},
          onProgress: (v){setState(() {_stackToView = 1;});},
          navigationDelegate: (NavigationRequest request) {
            Echo('navigationDelegate $request}');
            if (request.url.contains('success')) {

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        if(_stackToView==1)Center(child: const CircularProgressIndicator())
      ],
    );
  }




}
