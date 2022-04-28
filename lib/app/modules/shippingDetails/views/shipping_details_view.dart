import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/shipping_details_controller.dart';

class ShippingDetailsView extends GetView<ShippingDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShippingDetailsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ShippingDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
