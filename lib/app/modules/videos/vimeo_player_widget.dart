import 'dart:convert';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VimeoPlayerWidget extends StatelessWidget {
  const VimeoPlayerWidget({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeAppbar(),
            Expanded(
              child: link.contains('vimeo') ? AspectRatio(
                aspectRatio: 16 / 9,
                child:InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(_videoPage(link.split("/").last))),),
              ) : Center(
                child: kTextHeader(
                    'No Vimeo Video Attached', color: kColorPrimary,
                    bold: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _videoPage(String videoId) {
    final html = '''
            <html>
              <head>
                <style>
                  body {
                   background-color: white;
                   margin: 0px;
                   }
                </style>
                <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
                <meta http-equiv="Content-Security-Policy" 
                content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *; 
                img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
             </head>
             <body>
                <iframe 
                src="https://player.vimeo.com/video/$videoId?loop=0&autoplay=0&fullscreen" 
                width="100%" height="100%" frameborder="0" allow="fullscreen" 
                allowfullscreen></iframe>
             </body>
            </html>
            ''';
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }

}
