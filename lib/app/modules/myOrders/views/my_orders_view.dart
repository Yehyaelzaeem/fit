import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyOrdersView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MyOrdersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
