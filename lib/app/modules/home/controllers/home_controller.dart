import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final selectedService = 0.obs;
  final currectMenuIdex = 1.obs;
  RxList<String> slider = RxList();
  RxList<SingleSevice> servicesList = RxList();
  @override
  void onInit() {
    super.onInit();
    slider.add(
        'https://cdn.shortpixel.ai/spai/q_lossless+ret_img/https://planetpaleo.co/wp-content/uploads/2020/11/PALEO-DIET-SLIDER.png');
    slider.add('https://webhostingbuddy.com/wp-content/uploads/2016/12/fastest-web-hosting.jpg');

    servicesList.add(SingleSevice(name: 'service 1', icon: Icons.mediation));
    servicesList.add(SingleSevice(name: 'service 2', icon: Icons.medical_services));
    servicesList.add(SingleSevice(name: 'service 3', icon: Icons.workspaces_outline));
    servicesList.add(SingleSevice(name: 'service 4', icon: Icons.work));
    servicesList.add(SingleSevice(name: 'service 1', icon: Icons.mediation));
    servicesList.add(SingleSevice(name: 'service 2', icon: Icons.medical_services));
    servicesList.add(SingleSevice(name: 'service 3', icon: Icons.workspaces_outline));
    servicesList.add(SingleSevice(name: 'service 4', icon: Icons.work));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void updateCurrentIndex(int value) {
    currentIndex.value = value;
  }
}

class SingleSevice {
  String name;
  IconData icon;
  SingleSevice({required this.name, required this.icon});
}
