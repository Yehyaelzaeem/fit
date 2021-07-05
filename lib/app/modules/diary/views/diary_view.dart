import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/diary_controller.dart';

class DiaryView extends GetView<DiaryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DiaryView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DiaryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
