import 'package:app/app/utils/helper/assets_path.dart';
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

    servicesList.add(SingleSevice(name: 'Nutrition and Workout plans', image: kDoctor));
    servicesList.add(SingleSevice(name: 'Roof Workout', image: kDumbell));
    servicesList.add(SingleSevice(name: 'Physiotherapy', image: kRuning));
 servicesList.add(SingleSevice(name: 'Nutrition and Workout plans', image: kDoctor));
    servicesList.add(SingleSevice(name: 'Roof Workout', image: kDumbell));
    servicesList.add(SingleSevice(name: 'Physiotherapy', image: kRuning));
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
  String image;
  SingleSevice({required this.name, required this.image});
}
