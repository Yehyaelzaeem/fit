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
    slider.add('assets/img/ic_slider_1.png');
    slider.add('assets/img/ic_slider_2.png');
    slider.add('assets/img/ic_slider_3.png');

    servicesList.add(SingleSevice(name: 'service 1', icon: Icons.mediation));
    servicesList.add(SingleSevice(name: 'service 2', icon: Icons.medical_services));
    servicesList.add(SingleSevice(name: 'service 3', icon: Icons.workspaces_outline));
    servicesList.add(SingleSevice(name: 'service 4', icon: Icons.mediation));
    servicesList.add(SingleSevice(name: 'service 5', icon: Icons.medical_services));
    servicesList.add(SingleSevice(name: 'service 6', icon: Icons.workspaces_outline));
    servicesList.add(SingleSevice(name: 'service 7', icon: Icons.mediation));
    servicesList.add(SingleSevice(name: 'service 8', icon: Icons.medical_services));
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
