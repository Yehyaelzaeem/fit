/*
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../home/home_appbar.dart';

class NotificationPlan extends StatelessWidget {
  const NotificationPlan({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HomeAppbar(
              type: null,
              removeNotificationsCount: true,
            ),
            Expanded(
              child: Center(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(link)),
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
